https://github.com/andrix/python-snappy 

 

####using the python-snappy implementation we find these claims

- Compressing Snappy is 11 times faster than zlib when compressing
- Uncompressing Snappy is twice as fast as lib


####I guess we can assume "fast" to be attributed to fewer CPU cycles, so here is the machine profile I used to run the tests

> Hardware Overview:
> 
>   Model Name:	iMac
>   Model Identifier:	iMac17,1
>   Processor Name:	Intel Core i7
>   Processor Speed:	4 GHz
>   Number of Processors:	1
>   Total Number of Cores:	4
>   L2 Cache (per Core):	256 KB
>   L3 Cache:	8 MB
>   Memory:	16 GB

####start out with ~1500 KLR records from Splash ~256Mb
```bash
Peters-iMac:azure.kafka-streaming peter$ find estreaming-data/ -type f -printf '%s\n' | awk '{s+=$0} END {printf "Count: %u\nAverage size: %.2f> \n", NR, s/NR/1000k}'
Count: 1536
Average size: 173.75k
```
```bash
Peters-iMac:azure.kafka-streaming peter$ du -h estreaming-data/
258M estreaming-data/
```
###Test Large Files First
#####tar things up into a single archive to test large file. The sample data ends up tar'ing to 256Mb.
```bash
Peters-iMac:azure.kafka-streaming peter$ tar -cf estreaming-data.tar estreaming-data/ 
Peters-iMac:azure.kafka-streaming peter$ ll
drwxr-xr-x  1540 peter  staff    51K Apr 22 17:30 estreaming-data
-rw-r--r--     1 peter  staff   256M Apr 22 17:34 estreaming-data.tar
drwxr-xr-x     3 peter  staff   102B Sep 30  2015 nginx
drwxr-xr-x     8 peter  staff   272B Nov  4 18:57 node
drwxr-xr-x    16 peter  staff   544B Oct  1  2015 scripts
```
#####now compress with zlib (twice)
```bash
Peters-iMac:azure.kafka-streaming peter$ time gzip < estreaming-data.tar > estreaming-data.tar.gz
real 0m2.979s
user 0m2.833s
sys 0m0.103s
Peters-iMac:azure.kafka-streaming peter$ rm -fr estreaming-data.tar.gz estreaming-data.tar.snappy 
Peters-iMac:azure.kafka-streaming peter$ time gzip < estreaming-data.tar > estreaming-data.tar.gz
real 0m2.945s
user 0m2.831s
sys 0m0.069s
```
#####now compress with snappy (twice)
```bash
Peters-iMac:azure.kafka-streaming peter$ time python -m snappy -c estreaming-data.tar estreaming-data.tar.snappy

real 0m1.077s
user 0m0.920s
sys 0m0.118s
Peters-iMac:azure.kafka-streaming peter$ rm -fr estreaming-data.tar.snappy 
Peters-iMac:azure.kafka-streaming peter$ time python -m snappy -c estreaming-data.tar estreaming-data.tar.snappy
real 0m1.058s
user 0m0.919s
sys 0m0.102s
```
####So these results on these files show Snappy runs almost 3x as **fast* as zlib compression on the same large file of around 256Mb - but that seems to fall far short of 11 times as fast.
***User+Sys will tell you how much actual CPU time your process used across all CPUs**

####How about the compression rate?

#####If we look at the compress file sizes we see the following
```bash
Peters-iMac:azure.kafka-streaming peter$ ll
drwxr-xr-x  1540 peter  staff    51K Apr 22 17:30 estreaming-data
-rw-r--r--     1 peter  staff   256M Apr 22 17:34 estreaming-data.tar
-rw-r--r--     1 peter  staff    17M Apr 22 17:51 estreaming-data.tar.gz
-rw-r--r--     1 peter  staff    40M Apr 22 17:53 estreaming-data.tar.snappy
```
####So these results yield the following compression ratios:

|        | original size Mb | compressed size Mb | ratio |
|:------:|:----------------:|:------------------:|:-----:|
|  zlib  |        256       |         17         |  15:1 |
| snappy |        256       |         40         |  6:1  |

###Now Let's Try Small Files
####Iterate through the individual files (~1500) in the folder that was tar'd to make up the big file. These individual files are are an average size of 175k and the smallest is around 2k and the largest is about 3M. 

```bash
[vagrant@server-perf compression]$ ./count_files_and_calculate_avg_file_size_dir.sh estreaming-data/
Count: 1536
Average size: 173.75
```

```bash
[vagrant@server-perf compression]$ ls -lSr estreaming-data/ |less
-rw-r--r--. 1 vagrant vagrant    2053 Sep 24  2015 34RG-3396-0007-0924-103628-392.txt
...
-rw-r--r--. 1 vagrant vagrant 2995481 Sep 24  2015 29BD-3396-0007-0924-165906-454.txt
```

####The script to read each file and run a compression algorithm on each is here
```bash
#!/bin/sh

fx_txt='txt'
fx_gz='gz'
fx_snappy='snappy'

fldr=$1
compr_type=$2

function  gz_cmd {
  local f=$1
  local fn=$2
  local fx=$3
  echo "gzip < $f > $fldr/$fn.$fx_gz"
}
function  snappy_cmd {
  local f=$1
  local fn=$2
  local fx=$3
  #echo "python -m snappy -c $f $fldr/$fn.$fx_snappy"
  echo "cat $f |python -m snappy -c >$fldr/$fn.$fx_snappy"
}

FILES=$(find $fldr -name *$fx_txt -type f)
for f in $FILES
do
  fn=$(basename $f .$fx_txt)
  cmd=$($compr_type'_cmd' $f $fn $fx'_'$compr_type)
  eval $cmd
done
```
####First with zlib
```bash
Peters-iMac:azure.kafka-streaming peter$ time ./compress_files.sh estreaming-data/ gz
real	0m9.610s
user	0m5.004s
sys	 0m3.543s
```
####Next with snappy
```bash
Peters-iMac:azure.kafka-streaming peter$ time  ./compress_files.sh estreaming-data/ snappy
real	0m32.788s
user	0m18.150s
sys     0m11.509s
```
#####So python-snappy does take much longer to process a set of files rather than one large one, at least this python implementation does at any rate. It could be the implementation in python is stuck on IO rather than CPU and perhaps not really streaming the input from STDIN and time is taken to read the entire file into memory before it is compressed? Not sure, it still seems like it shouldn't take 3.5 times as long to process.

####Maybe python is just slower? Here is a python program to read a file line by line
```python
import sys

lc = 0
for line in open(sys.argv[1]):
    lc = lc + 1

print lc, sys.argv[1]
```

####Let's compare that to the wc command 
```bash
Peters-iMac:compression peter$ time python read_file.py estreaming-data.tar 
1 estreaming-data.tar
real	0m0.341s
user	0m0.078s
sys	 0m0.248s
Peters-iMac:compression peter$ time wc -l estreaming-data.tar 
       0 estreaming-data.tar
real	0m0.253s
user	0m0.203s
sys	0m0.040s
Peters-iMac:compression peter$ time python read_file.py estreaming-data.tar 
1 estreaming-data.tar

real	0m0.339s
user	0m0.077s
sys	0m0.247s
Peters-iMac:compression peter$ time wc -l estreaming-data.tar 
       0 estreaming-data.tar
real	0m0.253s
user	0m0.203s
sys	0m0.039s

```
#####I guess python could be slower
###What about compression rate on the individual files?



###References:
- [An Introduction to File Compression Tools on Linux Servers](https://www.digitalocean.com/community/tutorials/an-introduction-to-file-compression-tools-on-linux-servers)
- [Python bindings for the snappy google library](https://github.com/andrix/python-snappy)
- [Snappy A fast compressor/decompressor](http://google.github.io/snappy/)
- [A fast compressor/decompressor](https://github.com/google/snappy)
- [Java Performance Tuning Guide](http://java-performance.info)
- [LZ4 compression for Java](https://github.com/jpountz/lz4-java)
- [What do 'real', 'user' and 'sys' mean in the output of time(1)?](http://stackoverflow.com/questions/556405/what-do-real-user-and-sys-mean-in-the-output-of-time1)


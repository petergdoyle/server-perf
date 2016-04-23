https://github.com/andrix/python-snappy 

 

####using the python-snappy implementation we find these claims

- Compressing Snappy is 11 times faster than zlib when compressing
- Uncompressing Snappy is twice as fast as lib


####I guess we can assume "fast" to equate to fewer CPU cycles, so here is the machine profile I used to run the tests

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
#####tar things up into a single archive to test large files
```bash
Peters-iMac:azure.kafka-streaming peter$ tar -cf estreaming-data.tar estreaming-data/ 
Peters-iMac:azure.kafka-streaming peter$ ll
total 639944
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
####So these results on these files show Snappy runs almost 3x as **fast* a zlib compression on the same large file of around 256Mb
***User+Sys will tell you how much actual CPU time your process used across all CPUs**

####How about the compression rate?

#####If we look at the compress file sizes we see the following
```bash
Peters-iMac:azure.kafka-streaming peter$ ll
total 639944
drwxr-xr-x  1540 peter  staff    51K Apr 22 17:30 estreaming-data
-rw-r--r--     1 peter  staff   256M Apr 22 17:34 estreaming-data.tar
-rw-r--r--     1 peter  staff    17M Apr 22 17:51 estreaming-data.tar.gz
-rw-r--r--     1 peter  staff    40M Apr 22 17:53 estreaming-data.tar.snappy
```
####So these results show the following ratios of compression ratios

|        | original size Mb | compressed size Mb | ratio |
|:------:|:----------------:|:------------------:|:-----:|
|  zlib  |        256       |         17         |  15:1 |
| snappy |        256       |         40         |  6:1  |

###Now Let's Try Small Files
####Let;s iterate through the individual files (~1500) in the folder that was tar'd to make up the big file.

####The script to do this is here
```vim
#!/bin/sh

fldr="estreaming-data"
fx_txt='txt'
fx_gz='gz'
fx_snappy='snappy'

compr_type="snappy"

function  gzip_cmd {
  local f=$1
  local fn=$2
  local fx=$3
  echo "gzip < $f > $fldr/$fn.$fx_gz"
}
function  snappy_cmd {
  local f=$1
  local fn=$2
  local fx=$3
  echo "python -m snappy -c $f $fldr/$fn.$fx_snappy"
}

FILES=$(find $fldr -name *$fx_txt -type f)
for f in $FILES
do
  fn=$(basename $f .$fx_txt)
  cmd=$($compr_type'_cmd' $f $fn $fx_gz)
  eval $cmd
done

```
####First with zlib
```bash
Peters-iMac:azure.kafka-streaming peter$ time ./compress_files.sh 

real	0m9.610s
user	0m5.004s
sys	0m3.543s
```
####Next with snappy
```bash
Peters-iMac:azure.kafka-streaming peter$ time  ./compress_files.sh 

real	0m32.788s
user	0m18.150s
sys	0m11.509s
```
####So Snappy does seem to take much longer to process a set of files rather than one large one, at least this python implementation does at any rate.

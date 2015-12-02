### Perf Test Results
#### Echo Pattern - default configurations no tuning
- 10kb POST to Echo Server
- 100 users / 100 concurrent requests
- Apache Benchmark Test test 


#####Tomcat (servlet container : non-async api) 
```bash
[vagrant@server-perf scripts]$ ./run_ab_load_test_post_data.sh 
Enter number of users: 100
Enter number of concurrent requests: 100
Enter the url: http://localhost:5040/servlets-1.0-SNAPSHOT/Echo
Enter the data file (absolute or relative path): ../data/lorem-ipsum-10kb
running... ab -p ../data/lorem-ipsum-10kb -n 100 -c 100 http://localhost:5040/servlets-1.0-SNAPSHOT/Echo
This is ApacheBench, Version 2.3 <$Revision: 1430300 $>
Copyright 1996 Adam Twiss, Zeus Technology Ltd, http://www.zeustech.net/
Licensed to The Apache Software Foundation, http://www.apache.org/

Benchmarking localhost (be patient).....done


Server Software:        Apache-Coyote/1.1
Server Hostname:        localhost
Server Port:            5040

Document Path:          /servlets-1.0-SNAPSHOT/Echo
Document Length:        10179 bytes

Concurrency Level:      100
Time taken for tests:   0.093 seconds
Complete requests:      100
Failed requests:        0
Write errors:           0
Total transferred:      1030700 bytes
Total body sent:        1033700
HTML transferred:       1017900 bytes
Requests per second:    1071.58 [#/sec] (mean)
Time per request:       93.320 [ms] (mean)
Time per request:       0.933 [ms] (mean, across all concurrent requests)
Transfer rate:          10785.93 [Kbytes/sec] received
                        10817.32 kb/s sent
                        21603.25 kb/s total

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:        3    3   0.3      3       4
Processing:    42   57  11.6     58      88
Waiting:       12   52  11.9     57      82
Total:         46   60  11.5     61      91

Percentage of the requests served within a certain time (ms)
  50%     61
  66%     62
  75%     63
  80%     63
  90%     81
  95%     87
  98%     90
  99%     91
 100%     91 (longest request)
```

#####Jetty (servlet container: non-async api)

```bash
[vagrant@server-perf scripts]$ ./run_ab_load_test_post_data.sh 
Enter number of users: 100
Enter number of concurrent requests: 100
Enter the url: http://localhost:5050/servlets-1.0-SNAPSHOT/Echo
Enter the data file (absolute or relative path): ../data/lorem-ipsum-10kb
running... ab -p ../data/lorem-ipsum-10kb -n 100 -c 100 http://localhost:5050/servlets-1.0-SNAPSHOT/Echo
This is ApacheBench, Version 2.3 <$Revision: 1430300 $>
Copyright 1996 Adam Twiss, Zeus Technology Ltd, http://www.zeustech.net/
Licensed to The Apache Software Foundation, http://www.apache.org/

Benchmarking localhost (be patient).....done


Server Software:        Jetty(9.3.6.v20151106)
Server Hostname:        localhost
Server Port:            5050

Document Path:          /servlets-1.0-SNAPSHOT/Echo
Document Length:        10179 bytes

Concurrency Level:      100
Time taken for tests:   0.117 seconds
Complete requests:      100
Failed requests:        0
Write errors:           0
Total transferred:      1027900 bytes
Total body sent:        1033700
HTML transferred:       1017900 bytes
Requests per second:    855.64 [#/sec] (mean)
Time per request:       116.872 [ms] (mean)
Time per request:       1.169 [ms] (mean, across all concurrent requests)
Transfer rate:          8588.96 [Kbytes/sec] received
                        8637.42 kb/s sent
                        17226.38 kb/s total

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:        1    2   0.5      2       3
Processing:    20   72  24.1     71     113
Waiting:       20   72  24.2     71     112
Total:         21   74  24.0     73     115

Percentage of the requests served within a certain time (ms)
  50%     73
  66%     83
  75%    100
  80%    102
  90%    107
  95%    114
  98%    115
  99%    115
 100%    115 (longest request)
```
     
Nodejs
```bash
[vagrant@server-perf scripts]$ ./run_ab_load_test_post_data.sh 
Enter number of users: 100
Enter number of concurrent requests: 100
Enter the url: http://localhost:5020/Echo
Enter the data file (absolute or relative path): ../data/lorem-ipsum-10kb
running... ab -p ../data/lorem-ipsum-10kb -n 100 -c 100 http://localhost:5020/Echo
This is ApacheBench, Version 2.3 <$Revision: 1430300 $>
Copyright 1996 Adam Twiss, Zeus Technology Ltd, http://www.zeustech.net/
Licensed to The Apache Software Foundation, http://www.apache.org/

Benchmarking localhost (be patient).....done


Server Software:        
Server Hostname:        localhost
Server Port:            5020

Document Path:          /Echo
Document Length:        10179 bytes

Concurrency Level:      100
Time taken for tests:   0.038 seconds
Complete requests:      100
Failed requests:        0
Write errors:           0
Total transferred:      1025400 bytes
Total body sent:        1031500
HTML transferred:       1017900 bytes
Requests per second:    2652.52 [#/sec] (mean)
Time per request:       37.700 [ms] (mean)
Time per request:       0.377 [ms] (mean, across all concurrent requests)
Transfer rate:          26561.46 [Kbytes/sec] received
                        26719.48 kb/s sent
                        53280.94 kb/s total

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:        2    2   0.4      2       3
Processing:    13   23   5.3     21      34
Waiting:        8   22   6.9     20      34
Total:         17   26   5.5     24      37

Percentage of the requests served within a certain time (ms)
  50%     24
  66%     27
  75%     28
  80%     34
  90%     35
  95%     37
  98%     37
  99%     37
 100%     37 (longest request)
```

Nodejs (streaming request/response)
```bash
[vagrant@server-perf scripts]$ ./run_ab_load_test_post_data.sh 
Enter number of users: 100
Enter number of concurrent requests: 100
Enter the url: http://localhost:5020/EchoStream
Enter the data file (absolute or relative path): ../data/lorem-ipsum-10kb
running... ab -p ../data/lorem-ipsum-10kb -n 100 -c 100 http://localhost:5020/EchoStream
This is ApacheBench, Version 2.3 <$Revision: 1430300 $>
Copyright 1996 Adam Twiss, Zeus Technology Ltd, http://www.zeustech.net/
Licensed to The Apache Software Foundation, http://www.apache.org/

Benchmarking localhost (be patient).....done


Server Software:        
Server Hostname:        localhost
Server Port:            5020

Document Path:          /EchoStream
Document Length:        10179 bytes

Concurrency Level:      100
Time taken for tests:   0.060 seconds
Complete requests:      100
Failed requests:        0
Write errors:           0
Total transferred:      1025400 bytes
Total body sent:        1032100
HTML transferred:       1017900 bytes
Requests per second:    1663.84 [#/sec] (mean)
Time per request:       60.102 [ms] (mean)
Time per request:       0.601 [ms] (mean, across all concurrent requests)
Transfer rate:          16661.13 [Kbytes/sec] received
                        16769.99 kb/s sent
                        33431.12 kb/s total

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:        2    4   0.7      4       5
Processing:    34   44   5.3     41      54
Waiting:       11   41   9.8     41      54
Total:         38   48   5.2     46      58

Percentage of the requests served within a certain time (ms)
  50%     46
  66%     48
  75%     51
  80%     53
  90%     58
  95%     58
  98%     58
  99%     58
 100%     58 (longest request)
```


#### Echo Pattern - default configurations no tuning
- 1mb POST to Echo Server
- 100 users / 100 concurrent requests
- Apache Benchmark Test test 

Tomcat (non-async api)
```bash
[vagrant@server-perf scripts]$ ./run_ab_load_test_post_data.sh 
Enter number of users: 100
Enter number of concurrent requests: 100
Enter the url: http://localhost:5040/servlets-1.0-SNAPSHOT/Echo
Enter the data file (absolute or relative path): ../data/lorem-ipsum-1mb
running... ab -p ../data/lorem-ipsum-1mb -n 100 -c 100 http://localhost:5040/servlets-1.0-SNAPSHOT/Echo
This is ApacheBench, Version 2.3 <$Revision: 1430300 $>
Copyright 1996 Adam Twiss, Zeus Technology Ltd, http://www.zeustech.net/
Licensed to The Apache Software Foundation, http://www.apache.org/

Benchmarking localhost (be patient).....done


Server Software:        Apache-Coyote/1.1
Server Hostname:        localhost
Server Port:            5040

Document Path:          /servlets-1.0-SNAPSHOT/Echo
Document Length:        1020289 bytes

Concurrency Level:      100
Time taken for tests:   1.766 seconds
Complete requests:      100
Failed requests:        0
Write errors:           0
Total transferred:      102041700 bytes
Total body sent:        102044900
HTML transferred:       102028900 bytes
Requests per second:    56.64 [#/sec] (mean)
Time per request:       1765.621 [ms] (mean)
Time per request:       17.656 [ms] (mean, across all concurrent requests)
Transfer rate:          56439.12 [Kbytes/sec] received
                        56440.89 kb/s sent
                        112880.01 kb/s total

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:       24  332 554.7     44    1577
Processing:   138 1376 552.4   1663    1685
Waiting:        1 1302 577.6   1612    1632
Total:       1686 1708   8.0   1708    1742

Percentage of the requests served within a certain time (ms)
  50%   1708
  66%   1708
  75%   1709
  80%   1709
  90%   1710
  95%   1723
  98%   1738
  99%   1742
 100%   1742 (longest request)

```

Jetty (servlet container: non-async api)
```bash
[vagrant@server-perf scripts]$ ./run_ab_load_test_post_data.sh 
Enter number of users: 100
Enter number of concurrent requests: 100
Enter the url:  http://localhost:5050/servlets-1.0-SNAPSHOT/Echo
Enter the data file (absolute or relative path): ../data/lorem-ipsum-1mb
running... ab -p ../data/lorem-ipsum-1mb -n 100 -c 100 http://localhost:5050/servlets-1.0-SNAPSHOT/Echo
This is ApacheBench, Version 2.3 <$Revision: 1430300 $>
Copyright 1996 Adam Twiss, Zeus Technology Ltd, http://www.zeustech.net/
Licensed to The Apache Software Foundation, http://www.apache.org/

Benchmarking localhost (be patient).....done


Server Software:        Jetty(9.3.6.v20151106)
Server Hostname:        localhost
Server Port:            5050

Document Path:          /servlets-1.0-SNAPSHOT/Echo
Document Length:        1020289 bytes

Concurrency Level:      100
Time taken for tests:   1.974 seconds
Complete requests:      100
Failed requests:        0
Write errors:           0
Total transferred:      102036600 bytes
Total body sent:        102044900
HTML transferred:       102028900 bytes
Requests per second:    50.66 [#/sec] (mean)
Time per request:       1973.815 [ms] (mean)
Time per request:       19.738 [ms] (mean, across all concurrent requests)
Transfer rate:          50483.51 [Kbytes/sec] received
                        50487.62 kb/s sent
                        100971.13 kb/s total

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:        4  341 601.8     13    1814
Processing:   149 1595 597.8   1921    1942
Waiting:        1 1462 619.3   1808    1819
Total:       1932 1936   8.2   1934    1970

Percentage of the requests served within a certain time (ms)
  50%   1934
  66%   1934
  75%   1934
  80%   1934
  90%   1955
  95%   1960
  98%   1969
  99%   1970
 100%   1970 (longest request)
```

Nodejs (async request/response)
```bash
[vagrant@server-perf scripts]$ ./run_ab_load_test_post_data.sh 
Enter number of users: 100
Enter number of concurrent requests: 100
Enter the url: http://localhost:5020/Echo      
Enter the data file (absolute or relative path): ../data/lorem-ipsum-1mb
running... ab -p ../data/lorem-ipsum-1mb -n 100 -c 100 http://localhost:5020/Echo
This is ApacheBench, Version 2.3 <$Revision: 1430300 $>
Copyright 1996 Adam Twiss, Zeus Technology Ltd, http://www.zeustech.net/
Licensed to The Apache Software Foundation, http://www.apache.org/

Benchmarking localhost (be patient).....done


Server Software:        
Server Hostname:        localhost
Server Port:            5020

Document Path:          /Echo
Document Length:        1020289 bytes

Concurrency Level:      100
Time taken for tests:   2.589 seconds
Complete requests:      100
Failed requests:        0
Write errors:           0
Total transferred:      102036400 bytes
Total body sent:        102042700
HTML transferred:       102028900 bytes
Requests per second:    38.62 [#/sec] (mean)
Time per request:       2589.344 [ms] (mean)
Time per request:       25.893 [ms] (mean, across all concurrent requests)
Transfer rate:          38482.69 [Kbytes/sec] received
                        38485.07 kb/s sent
                        76967.76 kb/s total

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:        3  266 535.0     15    1842
Processing:   124 1702 531.3   1915    2241
Waiting:        1 1564 557.7   1833    1846
Total:       1887 1968  85.4   1951    2587

Percentage of the requests served within a certain time (ms)
  50%   1951
  66%   1959
  75%   1963
  80%   1968
  90%   2068
  95%   2089
  98%   2248
  99%   2587
 100%   2587 (longest request)

```

Nodejs (piped request/response)
```bash
[vagrant@server-perf scripts]$ ./run_ab_load_test_post_data.sh 
Enter number of users: 100
Enter number of concurrent requests: 100
Enter the url: http://localhost:5020/EchoStream
Enter the data file (absolute or relative path): ../data/lorem-ipsum-1mb
running... ab -p ../data/lorem-ipsum-1mb -n 100 -c 100 http://localhost:5020/EchoStream
This is ApacheBench, Version 2.3 <$Revision: 1430300 $>
Copyright 1996 Adam Twiss, Zeus Technology Ltd, http://www.zeustech.net/
Licensed to The Apache Software Foundation, http://www.apache.org/

Benchmarking localhost (be patient).....done


Server Software:        
Server Hostname:        localhost
Server Port:            5020

Document Path:          /EchoStream
Document Length:        1020289 bytes

Concurrency Level:      100
Time taken for tests:   1.384 seconds
Complete requests:      100
Failed requests:        0
Write errors:           0
Total transferred:      102036400 bytes
Total body sent:        102043300
HTML transferred:       102028900 bytes
Requests per second:    72.26 [#/sec] (mean)
Time per request:       1383.856 [ms] (mean)
Time per request:       13.839 [ms] (mean, across all concurrent requests)
Transfer rate:          72005.27 [Kbytes/sec] received
                        72010.14 kb/s sent
                        144015.40 kb/s total

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:        7  224 423.6     14    1312
Processing:    65 1145 424.1   1355    1369
Waiting:        1 1082 438.1   1305    1315
Total:       1364 1369   4.3   1368    1377

Percentage of the requests served within a certain time (ms)
  50%   1368
  66%   1370
  75%   1373
  80%   1373
  90%   1376
  95%   1377
  98%   1377
  99%   1377
 100%   1377 (longest request)
```
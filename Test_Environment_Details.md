#Server-Perf

##Test Environment

###CPU Info (identical engine1, engine2)
sc
	CPU Benchmark: 7011 http://www.cpubenchmark.net/cpu.php?cpu=Intel+Xeon+E3-1225+v3+%40+3.20GHz 
    processor	: 0,1,2,3 Quad Core 
    vendor_id	: GenuineIntel
    cpu family	: 6
    model		: 60
    model name	: Intel(R) Xeon(R) CPU E3-1225 v3 @ 3.20GHz
    cpu MHz		: 3200.125
    cache size	: 8192 KB
    siblings	: 4
    cpu cores	: 4



###Network Speed

engine1 -> engine2
```bash
[peter@engine1 ~]$ sudo iperf -s
------------------------------------------------------------
Server listening on TCP port 5001
TCP window size: 85.3 KByte (default)
------------------------------------------------------------
[  4] local 192.168.1.80 port 5001 connected with 192.168.1.81 port 56026
[ ID] Interval       Transfer     Bandwidth
[  4]  0.0-10.0 sec  1.09 GBytes   934 Mbits/sec
[peter@engine1 ~]$ iperf -c engine2
------------------------------------------------------------
Client connecting to engine2, TCP port 5001
TCP window size: 22.5 KByte (default)
------------------------------------------------------------
[  3] local 192.168.1.80 port 46625 connected with 192.168.1.81 port 5001
[ ID] Interval       Transfer     Bandwidth
[  3]  0.0-10.0 sec  1.09 GBytes   935 Mbits/sec

```

engine2 -> engine1

```bash
[peter@engine2 ~]$ iperf -c engine1 
------------------------------------------------------------
Client connecting to engine1, TCP port 5001
TCP window size: 22.5 KByte (default)
------------------------------------------------------------
[  3] local 192.168.1.81 port 56026 connected with 192.168.1.80 port 5001
[ ID] Interval       Transfer     Bandwidth
[  3]  0.0-10.0 sec  1.09 GBytes   935 Mbits/sec

[peter@engine2 ~]$ sudo iperf -s
------------------------------------------------------------
Server listening on TCP port 5001
TCP window size: 85.3 KByte (default)
------------------------------------------------------------
[  4] local 192.168.1.81 port 5001 connected with 192.168.1.80 port 46625
[ ID] Interval       Transfer     Bandwidth
[  4]  0.0-10.0 sec  1.09 GBytes   934 Mbits/sec
```
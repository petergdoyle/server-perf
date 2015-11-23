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

### Physical to Physical

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

###Physical to remote VM
```bash
[peter@engine1 ~]$ sudo iperf -c engine2 -p 15001
------------------------------------------------------------
Client connecting to engine2, TCP port 15001
TCP window size: 22.5 KByte (default)
------------------------------------------------------------
[  3] local 192.168.1.80 port 46741 connected with 192.168.1.81 port 15001
[ ID] Interval       Transfer     Bandwidth
[  3]  0.0-10.0 sec   904 MBytes   758 Mbits/sec
[peter@engine1 ~]$ sudo iperf -c engine2 -p 15001
------------------------------------------------------------
Client connecting to engine2, TCP port 15001
TCP window size: 22.5 KByte (default)
------------------------------------------------------------
[  3] local 192.168.1.80 port 46742 connected with 192.168.1.81 port 15001
[ ID] Interval       Transfer     Bandwidth
[  3]  0.0-10.0 sec   791 MBytes   664 Mbits/sec
```

###Physical to local VM
```bash
[peter@engine2 iperf]$ sudo iperf -c localhost -p 15001
------------------------------------------------------------
Client connecting to localhost, TCP port 15001
TCP window size:  648 KByte (default)
------------------------------------------------------------
[  3] local 127.0.0.1 port 50478 connected with 127.0.0.1 port 15001
[ ID] Interval       Transfer     Bandwidth
[  3]  0.0-10.5 sec   837 MBytes   668 Mbits/sec
[peter@engine2 iperf]$ sudo iperf -c localhost -p 15001
------------------------------------------------------------
Client connecting to localhost, TCP port 15001
TCP window size:  648 KByte (default)
------------------------------------------------------------
[  3] local 127.0.0.1 port 50479 connected with 127.0.0.1 port 15001
[ ID] Interval       Transfer     Bandwidth
[  3]  0.0-10.0 sec   809 MBytes   678 Mbits/sec
[peter@engine2 iperf]$ 
```

###Physical to remote Container
```bash
[peter@engine1 ~]$ sudo iperf -c engine2 -p 15001
------------------------------------------------------------
Client connecting to engine2, TCP port 15001
TCP window size: 22.5 KByte (default)
------------------------------------------------------------
[  3] local 192.168.1.80 port 46738 connected with 192.168.1.81 port 15001
[ ID] Interval       Transfer     Bandwidth
[  3]  0.0-10.0 sec  1.09 GBytes   935 Mbits/sec
```

###VM to VM (intra VM)

###Container to Container (intra-container)
```bash
[peter@engine2 iperf]$ client/docker_run.sh 
------------------------------------------------------------
Client connecting to iperf_server, TCP port 5001
TCP window size: 22.5 KByte (default)
------------------------------------------------------------
[  3] local 172.17.0.17 port 57902 connected with 172.17.0.16 port 5001
[ ID] Interval       Transfer     Bandwidth
[  3]  0.0-10.0 sec  58.1 GBytes  49.9 Gbits/sec
```
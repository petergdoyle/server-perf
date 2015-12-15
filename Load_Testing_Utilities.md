#Measuring Performance

##Benchmarking and Peformance toolsets
- httperf
- weighttp
- httpress
- siege
- JMeter
- tourbus
- loadui 
- ab - Apache HTTP server benchmarking tool
- curl-loader

###ab
ApacheBench (ab) is a single-threaded command line computer program for measuring the performance of HTTP web servers.[1] Originally designed to test the Apache HTTP Server, it is generic enough to test any web server.

ApacheBench will only use one operating system thread regardless of the concurrency level (specified by the -c parameter). In some cases, especially when benchmarking high-capacity servers, a single instance of ApacheBench can itself be a bottleneck. When using ApacheBench on hardware with multiple processor cores, additional instances of ApacheBench may be used in parallel to more fully saturate the target URL.
> *Example Usage*
GET
This will execute 100 HTTP GET requests, processing up to 10 requests concurrently, to the specified URL
```bash
	ab -n 100 -c 10 "http://en.wikipedia.org/wiki/Main_Page"
```
POST
This will execute 1500 POSTs to the target URL  processing up to 500 concurrently. The -p parameter specifies a POST and in this case to upload the file specified.
```bash
	 ab -p ../data/lorem-ipsum-10kb -T text/plain -n 1500 -c 500 http://localhost:5040/servlet/perf/async?sleep=500
```

###httperf

> Example Usage
> GET
> ```bash
> httperf --client=0/1 --server=localhost --port=5040 --uri=/servlet/perf/async --send-buffer=4096 --recv-buffer
> =16384 --num-conns=4000 --num-call 16 --rate=128 --timeout 5
> ```

###curl-loader
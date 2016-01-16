#!/bin/sh


docker run --rm -ti --net host --name iperf_server server-perf/base iperf -s

#docker run --rm -ti -p 0.0.0.0:15001:5001 -h iperfserver --name iperf_server server-perf/base -s

#!/bin/sh
. ../scripts/lib/docker_functions.sh
. ../scripts/lib/network_functions.sh

img_name='server-perf/netty'
container_name='server_perf_netty'

#start_cmd='java -jar target/TestBackend-0.0.1-SNAPSHOT.jar'

start_cmd="java -cp .:target/server-perf-netty-http-1.0-SNAPSHOT.jar \
com.cleverfishsoftware.serverperf.netty.http1.EchoServer \
5060"

port_map_1='-p 0.0.0.0:15060:5060'
network_port_mapped="$port_map_1 \
-h $container_name.dkr"
network="$network_port_mapped"

docker_run 15060

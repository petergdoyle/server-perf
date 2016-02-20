#!/bin/sh
. ../scripts/lib/docker_functions.sh
. ../scripts/lib/network_functions.sh

img_name='server-perf/undertow'

container_name='server_perf_undertow_native_5090'
#start_cmd='java -jar target/server-perf-undertow-1.0-SNAPSHOT.jar 5090'
start_cmd='java -cp .:target/server-perf-undertow-1.0-SNAPSHOT.jar com.cleverfishsoftware.serverperf.undertow.HelloWorldServer 5090'
network="$network_native"
docker_run 5090

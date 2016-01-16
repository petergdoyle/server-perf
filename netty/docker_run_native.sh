#!/bin/sh
. ../scripts/lib/docker_functions.sh
. ../scripts/lib/network_functions.sh


img_name='server-perf/netty'
container_name='server_perf_netty_native_5060'

start_cmd="java -jar target/TestBackend-0.0.1-SNAPSHOT.jar"

network="$network_native"

docker_run 5060

#!/bin/sh
. ../scripts/lib/docker_functions.sh
. ../scripts/lib/network_functions.sh

img_name='server-perf/undertow'

container_name='server_perf_undertow'
start_cmd='java -jar target/server-perf-undertow-1.0-SNAPSHOT.jar 5090'
port_map_1='-p 0.0.0.0:15090:5090'
network_port_mapped="$port_map_1 \
-h $container_name.dkr"
network="$network_port_mapped"
docker_run 15090

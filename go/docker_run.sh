#!/bin/sh
. ../scripts/lib/docker_functions.sh
. ../scripts/lib/network_functions.sh

img_name="server-perf/go"

container_name='server_perf_go_http'
start_cmd="bin/http_server"
port_map_1='-p 0.0.0.0:16000:6000'
network_port_mapped="$port_map_1 \
-h $container_name.dkr"
network="$network_port_mapped"
docker_run 16000

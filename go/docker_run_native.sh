#!/bin/sh
. ../scripts/lib/docker_functions.sh
. ../scripts/lib/network_functions.sh

img_name="server-perf/go"

container_name='server_perf_go_http_6000'
start_cmd="bin/http_server"
network="$network_native"
docker_run 6000

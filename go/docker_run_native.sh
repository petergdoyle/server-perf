#!/bin/sh
. ../scripts/lib/docker_functions.sh
. ../scripts/lib/network_functions.sh

img_name="server-perf/go"

container_name='server_perf_go_8080'

start_cmd="go run http_server.go"

network="$network_native"

docker_run 5080

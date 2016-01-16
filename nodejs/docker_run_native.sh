#!/bin/sh
. ../scripts/lib/docker_functions.sh
. ../scripts/lib/network_functions.sh

img_name='server-perf/nodejs'
volumes=""
network="$network_native"

container_name='server_perf_nodejs_express_native_5020'

start_cmd="node --harmony express_server.js"

docker_run 5020 4200



container_name='server_perf_nodejs_http_native_5021'

start_cmd="node --harmony http_server.js"

docker_run 5021 4200




container_name='server_perf_nodejs_http_clustered_native_5022'

start_cmd="node --harmony http_server_clustered.js"

docker_run 5022 4200

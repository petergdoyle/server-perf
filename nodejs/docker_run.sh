#!/bin/sh

. ../scripts/lib/docker_run.sh


img_name='server-perf/nodejs'
container_name='server_perf_nodejs_http_native'

start_cmd="node http_server.js"

volumes=""

port_map_1='-p 0.0.0.0:15021:5021'
port_map_2='-p 0.0.0.0:14200:4200'
network_port_mapped="$port_map_1 $port_map_2 \
-h $container_name.dkr"
network="$network_port_mapped"

docker_run


container_name='server_perf_nodejs_express_native'

start_cmd="node express_server.js"

volumes=""

port_map_1='-p 0.0.0.0:15020:5020'
port_map_2='-p 0.0.0.0:14200:4200'
network_port_mapped="$port_map_1 $port_map_2 \
-h $container_name.dkr"
network="$network_port_mapped"

docker_run

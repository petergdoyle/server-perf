#!/bin/sh
. ../scripts/lib/docker_functions.sh
. ../scripts/lib/network_functions.sh


img_name='server-perf/nodejs'


container_name='server_perf_nodejs_http'
start_cmd="node --harmony http_server.js"
port_map_1='-p 0.0.0.0:15021:5021'
port_map_2='-p 0.0.0.0:14221:4200'
network_port_mapped="$port_map_1 $port_map_2 \
-h $container_name.dkr"
network="$network_port_mapped"
docker_run 15021,14221


container_name='server_perf_nodejs_express'
start_cmd="node --harmony express_server.js"
port_map_1='-p 0.0.0.0:15020:5020'
port_map_2='-p 0.0.0.0:14220:4200'
network_port_mapped="$port_map_1 $port_map_2 \
-h $container_name.dkr"
network="$network_port_mapped"
docker_run 15020,14220

container_name='server_perf_nodejs_express_clustered'
start_cmd="node --harmony express_server_clustered.js"
port_map_1='-p 0.0.0.0:15020:5023'
port_map_2='-p 0.0.0.0:14223:4200'
network_port_mapped="$port_map_1 $port_map_2 \
-h $container_name.dkr"
network="$network_port_mapped"
docker_run 15023,14223


container_name='server_perf_nodejs_http_clustered'
start_cmd="node --harmony http_server_clustered.js"
port_map_1='-p 0.0.0.0:15022:5022'
port_map_2='-p 0.0.0.0:14222:4200'
network_port_mapped="$port_map_1 $port_map_2 \
-h $container_name.dkr"
network="$network_port_mapped"
docker_run 15022,14222

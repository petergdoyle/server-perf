#!/bin/sh

. ../scripts/lib/docker_functions.sh


img_name='server-perf/nodejs'
container_name='server_perf_nodejs_http'

start_cmd="node --harmony http_server.js"

port_map_1='-p 0.0.0.0:15021:5021'
port_map_2='-p 0.0.0.0:14221:4200'
network_port_mapped="$port_map_1 $port_map_2 \
-h $container_name.dkr"
network="$network_port_mapped"

docker_run

#
# open ports that services are running on in container
#
sudo firewall-cmd --add-port=15021/tcp
sudo firewall-cmd --add-port=14221/tcp



container_name='server_perf_nodejs_express'

start_cmd="node --harmony express_server.js"

port_map_1='-p 0.0.0.0:15020:5020'
port_map_2='-p 0.0.0.0:14220:4200'
network_port_mapped="$port_map_1 $port_map_2 \
-h $container_name.dkr"
network="$network_port_mapped"

docker_run

#
# open ports that services are running on in container
#
sudo firewall-cmd --add-port=15020/tcp
sudo firewall-cmd --add-port=14220/tcp



container_name='server_perf_nodejs_http_clustered'
start_cmd="node --harmony http_server_clustered.js"

port_map_1='-p 0.0.0.0:15022:5022'
port_map_2='-p 0.0.0.0:14222:4200'
network_port_mapped="$port_map_1 $port_map_2 \
-h $container_name.dkr"
network="$network_port_mapped"

docker_run

#
# open ports that services are running on in container
#
sudo firewall-cmd --add-port=15022/tcp
sudo firewall-cmd --add-port=14222/tcp

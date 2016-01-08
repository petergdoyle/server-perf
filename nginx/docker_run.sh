#!/usr/bin/env bash
. ../scripts/lib/docker_functions.sh

img_name='server-perf/nginx'
container_name='server_perf_nginx'

start_cmd="nginx -g 'daemon off;'"


port_map_1='-p 0.0.0.0:15000:5000'
network_port_mapped="$port_map_1 \
-h $container_name.dkr"
network="$network_port_mapped"

docker_run

#
# open ports that services are running on in container
#
sudo firewall-cmd --add-port=15000/tcp

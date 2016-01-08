#!/bin/sh
. ../scripts/lib/docker_functions.sh

img_name='server-perf/undertow'
container_name='server_perf_undertow'

start_cmd='java -jar target/undertow-1.0-SNAPSHOT.jar'

port_map_1='-p 0.0.0.0:15090:5090'
network_port_mapped="$port_map_1 \
-h $container_name.dkr"
network="$network_port_mapped"

docker_run

#
# open ports that services are running on in container
#
sudo firewall-cmd --add-port=15090/tcp

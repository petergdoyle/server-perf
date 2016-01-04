#!/bin/sh

. ../scripts/lib/docker_run.sh

img_name='serverperf/springboot'
container_name='server_perf_springboot'

start_cmd="java -jar target/springboot-1.0-SNAPSHOT.jar"

volumes="$shared_volume_base"

port_map_1='-p 0.0.0.0:5070:5070'
network_port_mapped="$port_map_1 \
-h $container_name.dkr"
network="$network_port_mapped"

docker_run

#
# open ports that services are running on in container
#
sudo firewall-cmd --add-port=5070/tcp

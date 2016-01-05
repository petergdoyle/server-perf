#!/bin/sh

. ../scripts/lib/docker_run.sh


image_name='server-perf/springboot'
container_name='server_perf_springboot_tomcat'

start_cmd="java -jar target/springboot-tomcat-1.0-SNAPSHOT.jar"
volumes=""
port_map_1='-p 0.0.0.0:5070:5070'
network_port_mapped="$port_map_1 \
-h $container_name.dkr"
network="$network_port_mapped"

docker_run

#
# open ports that services are running on in container
#
sudo firewall-cmd --add-port=5070/tcp


container_name='server_perf_springboot_undertow'

start_cmd="java -jar target/springboot-undertow-1.0-SNAPSHOT.jar"
volumes=""
port_map_1='-p 0.0.0.0:5075:5075'
network_port_mapped="$port_map_1 \
-h $container_name.dkr"
network="$network_port_mapped"

docker_run

#
# open ports that services are running on in container
#
sudo firewall-cmd --add-port=5075/tcp

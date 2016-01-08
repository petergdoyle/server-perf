#!/bin/sh

. ../scripts/lib/docker_functions.sh


img_name='server-perf/springboot'
container_name='server_perf_springboot_tomcat'

start_cmd="java -Dserver.port=5070 -jar target/springboot-tomcat-1.0-SNAPSHOT.jar"
volumes=""
port_map_1='-p 0.0.0.0:15070:5070'
network_port_mapped="$port_map_1 \
-h $container_name.dkr"
network="$network_port_mapped"

docker_run

#
# open ports that services are running on in container
#
sudo firewall-cmd --add-port=15070/tcp


container_name='server_perf_springboot_undertow'

start_cmd="java -Dserver.port=5072 -jar target/springboot-undertow-1.0-SNAPSHOT.jar"
volumes=""
port_map_1='-p 0.0.0.0:15072:5072'
network_port_mapped="$port_map_1 \
-h $container_name.dkr"
network="$network_port_mapped"

docker_run

#
# open ports that services are running on in container
#
sudo firewall-cmd --add-port=15072/tcp

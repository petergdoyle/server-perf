#!/bin/sh

. ../scripts/lib/docker_run.sh


img_name='server-perf/springboot'

volumes=""
network="$network_native"

container_name='server_perf_springboot_tomcat_native'
start_cmd="java -jar target/springboot-tomcat-1.0-SNAPSHOT.jar"

docker_run

#
# open ports that services are running on in container
#
sudo firewall-cmd --add-port=5070/tcp



container_name='server_perf_springboot_undertow_native'
start_cmd="java -jar target/springboot-undertow-1.0-SNAPSHOT.jar"

docker_run

#
# open ports that services are running on in container
#
sudo firewall-cmd --add-port=5075/tcp

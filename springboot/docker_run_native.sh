#!/bin/sh

. ../scripts/lib/docker_run.sh


img_name='server-perf/springboot'

volumes=""
network="$network_native"

#
# http://stackoverflow.com/questions/21083170/spring-boot-how-to-configure-portç
# for full reference - https://docs.spring.io/spring-boot/docs/current/reference/html/common-application-properties.html
#
ß
container_name='server_perf_springboot_tomcat_native'
start_cmd="java -Dserver.port=5070 -jar target/springboot-tomcat-1.0-SNAPSHOT.jar"

docker_run

#
# open ports that services are running on in container
#
sudo firewall-cmd --add-port=5070/tcp



container_name='server_perf_springboot_undertow_native'
start_cmd="java -Dserver.port=5072 -jar target/springboot-undertow-1.0-SNAPSHOT.jar"

docker_run

#
# open ports that services are running on in container
#
sudo firewall-cmd --add-port=5072/tcp

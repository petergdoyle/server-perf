#!/bin/sh
. ../scripts/lib/docker_functions.sh

img_name='server-perf/tomcat'
container_name='server_perf_tomcat'

shared_volume_1="$PWD/webapps:/tomcat/default/webapps"
port_map_1='-p 0.0.0.0:15040:8080'
network_port_mapped="$port_map_1 \
-h $container_name'.dkr'"
network="$network_port_mapped"

start_cmd='/tomcat/default/bin/catalina.sh run'

docker_run

#
# open ports that services are running on in container
#
sudo firewall-cmd --add-port=15040/tcp

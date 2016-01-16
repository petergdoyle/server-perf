#!/bin/sh
. ../scripts/lib/docker_functions.sh
. ../scripts/lib/network_functions.sh


img_name='server-perf/jetty'

container_name='server_perf_jetty'
start_cmd="java -jar /jetty/default/start.jar jetty.http.port=5050 jetty.ssl.port=5440"
port_map_1='-p 0.0.0.0:15050:5050'
network_port_mapped="$port_map_1 \
-h $container_name.dkr"
network="$network_port_mapped"
docker_run 15050

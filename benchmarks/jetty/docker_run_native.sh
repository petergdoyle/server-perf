#!/bin/sh

. ../scripts/lib/docker_functions.sh


img_name='server-perf/jetty'
container_name='server_perf_jetty_native_5050'

start_cmd="java -jar /jetty/default/start.jar jetty.http.port=5050 jetty.ssl.port=5443"

network="$network_native"

docker_run

#
# open ports that services are running on in container
#
sudo firewall-cmd --add-port=5050/tcp

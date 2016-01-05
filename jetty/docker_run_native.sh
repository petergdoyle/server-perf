#!/bin/sh

. ../scripts/lib/docker_run.sh


image_name='server-perf/jetty'
container_name='server_perf_jetty_native'

start_cmd="java -jar /jetty/default/start.jar jetty.http.port=5050 jetty.ssl.port=5443"


#shared_volume_1="-v $PWD/base:/base"
#volumes="$shared_volume_1"
volumes=""

network="$network_native"

docker_run

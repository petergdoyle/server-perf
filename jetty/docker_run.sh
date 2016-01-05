#!/bin/sh

. ../scripts/lib/docker_run.sh


image_name='server-perf/jetty'
container_name='server_perf_jetty'

start_cmd="java -jar /jetty/default/start.jar jetty.http.port=5050 jetty.ssl.port=5440"

shared_volume_1="-v $PWD/base:/base"
volumes="$shared_volume_1"

port_map_1='-p 0.0.0.0:15020:5020'
port_map_2='-p 0.0.0.0:15021:5021'
port_map_3='-p 0.0.0.0:14200:4200'
network_port_mapped="$port_map_1 $port_map_2 $port_map_3 \
-h $container_name.dkr"
network="$network_port_mapped"

docker_run


shell_cmd='/bin/bash'
start_cmd='java \
    -Dcom.sun.management.jmxremote \
    -Dcom.sun.management.jmxremote.ssl=false \
    -Dcom.sun.management.jmxremote.authenticate=false \
    -Dcom.sun.management.jmxremote.local.only=false \
    -Dcom.sun.management.jmxremote.port=1099 \
-jar /jetty/default/start.jar OPTIONS=Server,jmx etc/jetty-jmx.xml etc/jetty.xml'
port_map_1='0.0.0.0:5050:8080'
port_map_2='0.0.0.0:10001:1099'
daemon='-d'
transient='--rm'
mode=$daemon

docker stop $container_name && docker rm $container_name

docker_cmd="docker run $mode -ti \
  --name $container_name \
  -v $shared_volume_1 \
  -p $port_map_1 -p $port_map_2 \
  -h $container_name.dkr \
  $img_name \
  $start_cmd"

echo "running command... $docker_cmd"
eval $docker_cmd

sleep 3s
docker ps -a

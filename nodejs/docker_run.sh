#!/bin/sh

img_name='serverperf/nodejs'
container_name='server_perf_nodejs'
shell_cmd='/bin/bash'
start_cmd='/usr/bin/supervisord -c /docker/supervisord.conf'
shared_volume_1="$PWD:/docker"
port_map_1='5020:5020'
port_map_2='5021:5021'
port_map_3='4200:4200'

networking_mapped="-p $port_map_1 -p $port_map_2 -p $port_map_3 \
-h $container_name.dkr"
networking_native="--net host"
networking=$networking_mapped

volumes="$shared_volume_1"

docker stop $container_name && docker rm $container_name

docker_cmd="docker run -d -ti \
--name $container_name \
$volumes
$networking \
$img_name \
$start_cmd"

echo "running command... $docker_cmd"
eval $docker_cmd

sleep 3s
docker ps -a

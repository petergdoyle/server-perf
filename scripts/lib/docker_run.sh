#!/bin/sh

#usage: import into a shell, override variables in docker_run() and call docker_run


## override img_name and container_name as required
docker.io/centos'
container_name='docker_io_centos'

## override start_cmd if required (not sometmes it is not necessary when CMD is set in Dockerfile)
shell_cmd='/bin/bash'
supervisord_cmd='/usr/bin/supervisord -c /etc/supervisord.conf'
start_cmd="$shell_cmd"

## override volumes if required
shared_volume_base="-v $PWD:/docker"
volumes="$shared_volume_base"

## overrid network if required
sample_port_map_1='-p 0.0.0.0:8080:8080'
sample_port_map_2='-p 0.0.0.0:80:80'
network_mapped="$sample_port_map_1 $sample_port_map_2 \
-h $container_name.dkr" # if running native network then you cannot specify a hostname for the container
network_native="--net host"
network_default=""
network="$network_default"

daemon='-d'
transient='--rm'
mode=$daemon

#clean up old containers
docker_clean() {
  container_status=$(docker ps -a --filter=name=$container_name| grep $container_name)
  #stop if exists and running
  test "$(echo $container_status| grep Up)" != '' && (docker stop $container_name)
  #remove if exists
  test "$(echo $container_status)" != '' && (docker rm $container_name)
}


docker_run() {
  if [ -e $container_name ]; then
    echo "variable container_name is not set. cannot continue"
    return 1
  fi
  if [ -e $img_name ]; then
    echo "variable img_name is not set. cannot continue"
    return 1
  fi
  docker_clean
  docker_cmd="docker run $mode -ti \
  --name $container_name \
  $volumes \
  $network \
  $img_name \
  $start_cmd"
  echo "running command... $docker_cmd"
  eval $docker_cmd
  sleep 3s
  docker ps -a
}

#!/bin/sh

## override img_name and container_name as required
#img_name='docker.io/centos'
#container_name='docker_io_centos'

## override start_cmd if required (not sometmes it is not necessary when CMD is set in Dockerfile)
shell_cmd='/bin/bash'
supervisord_cmd='/usr/bin/supervisord -c /etc/supervisord.conf'
start_cmd="$shell_cmd"

## override volumes if required
shared_volume_base="-v $PWD:/docker"
volumes="$shared_volume_base"

## overrid network if required
#sample_port_map_1='-p 0.0.0.0:8080:8080'
#sample_port_map_2='-p 0.0.0.0:80:80'
#network_mapped="$sample_port_map_1 $sample_port_map_2 \
#-h $container_name.dkr" # if running native network then you cannot specify a hostname for the container
network_native="--net host"
network_default=""
network="$network_default"

daemon='-d'
transient='--rm'
mode=$daemon

docker_build_all() {
  no_cache=$1

  for each in $(find . -type f -name 'Dockerfile' -exec dirname {} \;); do
    cd $each

    echo "building $each container"

    ./docker_build.sh $no_cache

    if [ $? -ne 0 ]; then
      echo -e "\e[1;31m the docker build for $each did not complete successfully \e[0m"
    else
      echo -e "\e[30;48;5;82m the docker build for $each built successfully \e[0m"
    fi

    cd -
  done
}

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


docker_run_all_template() {

  cmd=$1

  for each in $(find . -type f -name 'Dockerfile' -exec dirname {} \;); do
    cd $each

    echo "running the container specified in $each "

    eval $cmd

    if [ $? -ne 0 ]; then
      echo -e "\e[1;31m the docker run for $each did not complete successfully \e[0m"
    else
      echo -e "\e[30;48;5;82m the docker run for $each built successfully \e[0m"
    fi

    cd -
  done
}


docker_run_all_native() {

  docker_run_all_template './docker_run_native.sh'

}

docker_run_all() {

  docker_run_all_template './docker_run.sh'

}

docker_stop_all_containers() {
  for each in $(docker ps |grep server_perf |awk 'NF>1{print $NF}'); do
    docker stop $each
  done
}

docker_remove_all_containers() {
  for each in $(docker ps -a|grep server_perf |awk 'NF>1{print $NF}'); do
    docker stop $each
  done
  for each in $(docker ps -a|grep server_perf |awk 'NF>1{print $NF}'); do
    docker rm $each
  done
}

docker_cleanup_dangling_images() {
  dangling_images=$(docker images -q --filter 'dangling=true')
  if [ "$dangling_images" != '' ]; then
    cmd="docker rmi $dangling_images"
    echo "running... $cmd"
    eval $cmd
  fi
}

docker_remove_all_images() {
  docker_cleanup_dangling_images
  for each in $(docker images| grep server-perf| awk '{print $3;}'); do
    docker rmi $each
  done
}

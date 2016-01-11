#!/bin/sh

docker_build() {
  no_cache=$1

  if [ -e $img_name ]; then
    echo "variable img_name is not set. cannot continue"
    return 1
  fi
  if [ -n "$no_cache" ]; then echo "--no_cache"; else echo "cache"; fi

  docker build $no_cache -t=$img_name .

}

docker_build_all() {
  no_cache=$1

  #special base build
  cd base
  ./docker_build.sh $no_cache
  cd -
  if [ $? -ne 0 ]; then
    echo -e "\e[1;31m the docker build for server-perf/base did not complete successfully \e[0m"
    exit
  else
    echo -e "\e[30;48;5;82m the docker build for server-perf/base built successfully \e[0m"
  fi
  # jdk is out of the base because it adds about 500Mb to the image and
  # it is not needed by may containers
  cd jdk
  ./docker_build.sh $no_cache
  cd -
  if [ $? -ne 0 ]; then
    echo -e "\e[1;31m the docker build for server-perf/basejdk did not complete successfully \e[0m"
    exit
  else
    echo -e "\e[30;48;5;82m the docker build for server-perf/basejdk built successfully \e[0m"
  fi

  for each in $(find . -type f -name 'Dockerfile' -exec dirname {} \;); do

    if [[ "$each" == './base' || "$each" == './jdk' ]]; then
      continue
    fi

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


docker_clean() {
  if [ -e $container_name ]; then
    echo "variable container_name is not set. cannot continue"
    return 1
  fi
  container_status=$(docker ps -a --filter=name=$container_name| grep $container_name)
  #stop if exists and running
  test "$(echo $container_status| grep Up)" != '' && (docker stop $container_name)
  #remove if exists
  test "$(echo $container_status)" != '' && (docker rm $container_name)
}


## override start_cmd if required (note sometimes it is not necessary when CMD is set in Dockerfile)
shell_cmd='/bin/bash'
supervisord_cmd='/usr/bin/supervisord -c /etc/supervisord.conf'
start_cmd="$shell_cmd"

## override volumes if required
shared_volume_base="-v $PWD:/docker"
volumes=""
network_native="--net host"
network_default=""
network="$network_default"

daemon='-d'
transient='--rm'
mode=$daemon

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
    cmd="docker stop $each"
    echo $cmd
    eval $cmd
  done
}

docker_start_all_native_containers() {
  for each in $(docker ps -a|grep server_perf |grep native |awk 'NF>1{print $NF}'); do
    cmd="docker start $each"
    echo $cmd
    eval $cmd
  done
}

docker_start_all_containers() {
  for each in $(docker ps -a|grep server_perf |awk 'NF>1{print $NF}'); do
    cmd="docker start $each"
    echo $cmd
    eval $cmd
  done
}

docker_remove_all_containers() {
  for each in $(docker ps -a|grep server_perf |awk 'NF>1{print $NF}'); do
    cmd="docker stop $each"
    echo $cmd
    eval $cmd
  done
  for each in $(docker ps -a|grep server_perf |awk 'NF>1{print $NF}'); do
    cmd="docker rm $each"
    echo $cmd
    eval $cmd
  done
  # stopy any ... docker stop $(docker ps -a -q)
}

docker_cleanup_dangling_images() {
  dangling_images=$(docker images -q --filter 'dangling=true')
  if [ "$dangling_images" != '' ]; then
    cmd="docker rmi -f $dangling_images"
    echo $cmd
    eval $cmd
  fi
}

docker_remove_all_images() {
  docker_cleanup_dangling_images
  for each in $(docker images| grep server-perf| awk '{print $3;}'); do
    cmd="docker rmi -f $each"
    echo $cmd
    eval $cmd
  done
}

docker_htop() {
  container_name=$1
  if [ -e $container_name ]; then
    echo "variable container_name is not set. cannot continue"
    return 1
  fi
  docker exec -ti $container_name /usr/bin/htop
}

docker_top() {
  container_name=$1
  pid=$2
  if [ -e $container_name ]; then
    echo "variable container_name is not set. cannot continue"
    return 1
  fi
  if [ -e $pid ]; then
    echo "variable pid is not set. cannot continue"
    return 1
  fi
  docker exec -ti $container_name /usr/bin/top -H -p $pid
}

docker_iftop() {
  container_name=$1
  if [ -e $container_name ]; then
    echo "variable container_name is not set. cannot continue"
    return 1
  fi
  docker exec -ti $container_name /usr/sbin/iftop
}

docker_shell() {
  container_name=$1
  if [ -e $container_name ]; then
    echo "variable container_name is not set. cannot continue"
    return 1
  fi
  docker exec -ti $container_name /bin/bash
}

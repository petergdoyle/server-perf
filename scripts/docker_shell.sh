#!/bin/sh

container_name=$1

docker_shell() {
  if [ -e $container_name ]; then
    echo "variable container_name is not set. cannot continue"
    return 1
  fi
  docker exec -ti $container_name /bin/bash
}

docker_shell

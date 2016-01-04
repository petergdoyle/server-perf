#!/bin/sh

docker_top() {
  if [ -e $container_name ]; then
  echo "variable container_name is not set. cannot continue"
  return 1
  fi

  if [ -e $pid ]; then
    echo "variable pid is not set. by default the docker CMD will be pid 1, but when using supervisor that is not likely the pid you are interested in. cannot continue"
    return 1
  fi
  docker exec -ti $container_name /usr/bin/top -H -p $pid
}

#!/bin/sh

docker_cleanup_dangling_images() {
  dangling_images=$(docker images -q --filter 'dangling=true')
  if [ "$dangling_images" != '' ]; then
    cmd="docker rmi $dangling_images"
    echo "running... $cmd"
    eval $cmd
  fi
}
docker_cleanup_dangling_images

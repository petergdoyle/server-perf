#!/bin/sh

. scripts/lib/docker_clean_up_dangling_images.sh

no_cache=$1

for each in $(find . -type f -name 'Dockerfile' -exec dirname {} \;); do
  cd $each

  echo "building $each container"

  ./docker_build.sh

  if [ $? -ne 0 ]; then
    echo -e "\e[1;31m the docker build for $each did not complete successfully \e[0m"
  else
    echo -e "\e[30;48;5;82m the docker build for $each built successfully \e[0m"
  fi

  cd -
done

docker_cleanup_dangling_images

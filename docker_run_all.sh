#!/bin/sh

for each in $(find . -type f -name 'Dockerfile' -exec dirname {} \;); do
  cd $each

  echo "running the container specified in $each "

  ./docker_run.sh

  if [ $? -ne 0 ]; then
    echo -e "\e[1;31m the docker run for $each did not complete successfully \e[0m"
  else
    echo -e "\e[30;48;5;82m the docker run for $each built successfully \e[0m"
  fi

  cd -
done

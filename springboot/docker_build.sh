#!/bin/sh

. ../scripts/lib/docker_build.sh

img_name='serverperf/springboot'

mvn clean install

docker_build $1

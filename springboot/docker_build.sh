#!/bin/sh

. ../scripts/lib/docker_build.sh

img_name='serverperf/springboot'

docker_build $1

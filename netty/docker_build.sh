#!/bin/sh

. ../scripts/lib/docker_build.sh

img_name='serverperf/netty'

docker_build $1

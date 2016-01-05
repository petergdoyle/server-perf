#!/bin/sh

. ../scripts/lib/docker_build.sh


img_name='server-perf/netty'

docker_build $1

#!/bin/sh

. ../scripts/lib/docker_build.sh

no_cache=$1

img_name='server-perf/iperf'

docker_build $1

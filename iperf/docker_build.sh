#!/bin/sh

. ../scripts/lib/docker_build.sh

img_name='server-perf/iperf'

docker_build $1

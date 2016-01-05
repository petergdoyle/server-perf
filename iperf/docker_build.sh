#!/bin/sh

. ../scripts/lib/docker_build.sh

image_name='server-perf/iperf'

docker_build $1

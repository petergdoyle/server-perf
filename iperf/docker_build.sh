#!/bin/sh

. ../scripts/lib/docker_build.sh

img_name='serverperf/iperf'

docker_build $1

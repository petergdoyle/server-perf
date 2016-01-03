#!/bin/sh

. ../scripts/lib/docker_build.sh

img_name='serverperf/jetty'

docker_build $1

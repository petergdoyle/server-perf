#!/bin/sh

. ../scripts/lib/docker_build.sh

img_name='serverperf/nodejs'

docker_build $1

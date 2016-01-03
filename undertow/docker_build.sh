#!/bin/sh

. ../scripts/lib/docker_build.sh

img_name='serverperf/undertow'

docker_build $1

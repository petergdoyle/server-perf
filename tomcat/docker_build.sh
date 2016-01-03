#!/bin/sh

. ../scripts/lib/docker_build.sh

img_name='serverperf/tomcat'

docker_build $1

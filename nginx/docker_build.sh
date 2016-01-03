#!/bin/sh

. ../scripts/lib/docker_build.sh

img_name='serverperf/nginx_http'

docker_build $1

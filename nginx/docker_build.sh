#!/bin/sh

. ../scripts/lib/docker_build.sh


img_name='server-perf/nginx_http'

docker_build $1

#!/bin/sh
. ../scripts/lib/docker_functions.sh
no_cache=$1

img_name='server-perf/nginx_http'

docker_build $no_cache

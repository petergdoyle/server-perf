#!/bin/sh

. ../scripts/lib/docker_build.sh


image_name='server-perf/nginx_http'

docker_build $1

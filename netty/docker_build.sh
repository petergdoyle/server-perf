#!/bin/sh

set -e

. ../scripts/lib/docker_functions.sh

img_name='server-perf/netty'
no_cache=$1

. ./clean_and_build.sh

docker_build $no_cache

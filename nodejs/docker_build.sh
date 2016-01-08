#!/bin/sh

. ../scripts/lib/docker_functions.sh

no_cache=$1

. ./clean_and_build.sh

img_name='server-perf/nodejs'

docker_build $no_cache

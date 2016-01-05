#!/bin/sh

. ../scripts/lib/docker_build.sh
. ../scripts/lib/docker_cleanup_dangling_images.sh


img_name='server-perf/springboot'

no_cache=$1

. ./clean_and_build.sh

docker_build $no_cache \
&& docker_cleanup_dangling_images

#!/bin/sh

. ../scripts/lib/docker_build.sh
. ../scripts/lib/docker_cleanup_dangling_images.sh

no_cache=$1

image_name='server-perf/jetty'

. ./clean_and_build.sh

docker_build $no_cache \
&& docker_cleanup_dangling_images

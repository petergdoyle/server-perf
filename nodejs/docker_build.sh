#!/bin/sh

. ../scripts/lib/docker_build.sh

if [ -d "node_modules" ]; then rm -vfr node_modules; fi
npm install

no_cache=$1

img_name='server-perf/nodejs'

docker_build $no_cache

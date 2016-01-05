#!/bin/sh

. ../scripts/lib/docker_build.sh

if [ -d "node_modules" ]; then rm -vfr node_modules; fi
npm install


img_name='server-perf/nodejs'

docker_build $1

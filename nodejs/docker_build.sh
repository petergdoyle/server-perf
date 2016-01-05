#!/bin/sh

. ../scripts/lib/docker_build.sh

if [ -d "node_modules" ]; then rm -fr node_modules; fi
npm install

img_name='serverperf/nodejs'

docker_build $1

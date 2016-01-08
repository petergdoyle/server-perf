#!/bin/sh

. ../scripts/lib/docker_functions.sh

set -e

no_cache=$1

img_name='server-perf/undertow'

mvn clean install

docker_build $no_cache

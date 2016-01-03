#!/bin/sh

. ../scripts/lib/docker_build.sh

img_name='serverperf/undertow'

mvn clean install && docker_build $1

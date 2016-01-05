#!/bin/sh

. ../scripts/lib/docker_build.sh


image_name='server-perf/undertow'

mvn clean install && docker_build $1

#!/bin/sh

. ../scripts/lib/docker_functions.sh


img_name='server-perf/undertow'

mvn clean install && docker_build $1

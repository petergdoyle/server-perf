#!/bin/sh
. ../scripts/lib/docker_functions.sh

img_name='server-perf/tools'

container_name='server_perf_tools'
start_cmd='/bin/bash'
network="$network_native"
docker_run

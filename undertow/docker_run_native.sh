#!/bin/sh
. ../scripts/lib/docker_functions.sh
. ../scripts/lib/network_functions.sh

img_name='server-perf/undertow'

container_name='server_perf_undertow_native_5090'
start_cmd='java -jar target/undertow-1.0-SNAPSHOT.jar'
network="$network_native"
docker_run 5090

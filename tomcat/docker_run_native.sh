#!/bin/sh
. ../scripts/lib/docker_functions.sh
. ../scripts/lib/network_functions.sh

img_name='server-perf/tomcat'

container_name='server_perf_tomcat_native_5040'
start_cmd='/tomcat/default/bin/catalina.sh run'
network="$network_native"
docker_run 5040

#!/usr/bin/env bash
. ../scripts/lib/docker_functions.sh

docker run -d -p 0.0.0.0:5000:80 -h nginx.dkr --name nginx_http server-perf/nginx_http  \
nginx -g "daemon off;"
#!/bin/sh

. ../scripts/lib/docker_run.sh

img_name='server-perf/nginx'
container_name='server_perf_nginx_native'

start_cmd="nginx -g 'daemon off;'"

volumes=""

port_map_1='-p 0.0.0.0:15000:5000'
network_port_mapped="$port_map_1 \
-h $container_name.dkr"
network="$network_port_mapped"

docker_run

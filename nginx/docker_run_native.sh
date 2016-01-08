#!/bin/sh
. ../scripts/lib/docker_run.sh

img_name='server-perf/nginx'
volumes=""
network="$network_native"

container_name='server_perf_nginx_native'

start_cmd="nginx -g 'daemon off;'"

docker_run

#
# open ports that services are running on in container
#
sudo firewall-cmd --add-port=5000/tcp

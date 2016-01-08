#!/bin/sh
. ../scripts/lib/docker_functions.sh

img_name='server-perf/nginx'

network="$network_native"

container_name='server_perf_nginx_native_5000'

start_cmd="nginx -g 'daemon off;'"

docker_run

#
# open ports that services are running on in container
#
sudo firewall-cmd --add-port=5000/tcp

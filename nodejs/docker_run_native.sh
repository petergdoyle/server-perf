#!/bin/sh

. ../scripts/lib/docker_run.sh


image_name='server-perf/nodejs'
container_name='server_perf_nodejs_http_native'

start_cmd="node http_server.js"

volumes=""

network="$network_native"

docker_run

#
# open ports that services are running on in container
#
sudo firewall-cmd --add-port=5021tcp




container_name='server_perf_nodejs_express_native'

start_cmd="node express_server.js"

volumes=""

docker_run

#
# open ports that services are running on in container
#
sudo firewall-cmd --add-port=5020/tcp



sudo firewall-cmd --add-port=4200/tcp

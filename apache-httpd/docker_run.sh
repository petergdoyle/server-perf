#!/bin/sh
. ../scripts/lib/docker_functions.sh
. ../scripts/lib/network_functions.sh

img_name='server-perf/apache2'
container_name='server_perf_apache'

port_map_1='-p 0.0.0.0:15010:5010'
network_port_mapped="$port_map_1 \
-h $container_name'.dkr'
network="$network_port_mapped"

start_cmd="/usr/sbin/httpd -d /var/www/html -f /etc/httpd/conf/httpd.conf -e info -DFOREGROUND"

docker_run 15010

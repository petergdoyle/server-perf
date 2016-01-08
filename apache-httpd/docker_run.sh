#!/bin/sh
. ../scripts/lib/docker_functions.sh

img_name='server-perf/apache2'
container_name='server_perf_apache'

port_map_1='-p 0.0.0.0:15010:5010'
network_port_mapped="$port_map_1 \
-h $container_name'.dkr'"
network="$network_port_mapped"

start_cmd="/usr/sbin/httpd -d /var/www/html -f /etc/httpd/conf/httpd.conf -e info -DFOREGROUND"

docker_run

#
# open ports that services are running on in container
#
sudo firewall-cmd --add-port=15010/tcp

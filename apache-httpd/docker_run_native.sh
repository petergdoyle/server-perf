#!/bin/sh
. ../scripts/lib/docker_functions.sh

img_name="server-perf/apache2"

container_name='server_perf_apache_native_5010'

start_cmd="/usr/sbin/httpd -d /var/www/html -f /etc/httpd/conf/httpd.conf -e info -DFOREGROUND"

network="$network_native"

docker_run

#
# open ports that services are running on in container
#
sudo firewall-cmd --add-port=5010/tcp

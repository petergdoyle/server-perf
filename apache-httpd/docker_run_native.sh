#!/bin/sh
. ../scripts/lib/docker_functions.sh
. ../scripts/lib/network_functions.sh

img_name="server-perf/apache2"

container_name='server_perf_apache_native_5010'

start_cmd="/usr/sbin/httpd -d /var/www/html -f /etc/httpd/conf/httpd.conf -e info -DFOREGROUND"

network="$network_native"

docker_run 5010

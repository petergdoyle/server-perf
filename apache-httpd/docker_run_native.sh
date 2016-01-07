#!/bin/sh

. ../scripts/lib/docker_run.sh

img_name="server-perf/apache2"

container_name='server_perf_apache_native'

start_cmd="/usr/sbin/httpd -d /var/www/html -f /etc/httpd/conf/httpd.conf -e info -DFOREGROUND"

volumes=""

network="$network_native"

docker_run

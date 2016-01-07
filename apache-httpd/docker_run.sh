#!/bin/sh

#!/bin/sh

. ../scripts/lib/docker_run.sh

img_name='server-perf/tomcat'
container_name='server_perf_apache'

shared_volume_1=""
port_map_1='0.0.0.0:5010:5010'
network_port_mapped="$port_map_1 \
-h $container_name'.dkr'"
network="$network_port_mapped"

start_cmd="/usr/sbin/httpd -d /var/www/html -f /etc/httpd/conf/httpd.conf -e info -DFOREGROUND"

docker_run

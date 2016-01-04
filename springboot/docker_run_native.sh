#!/bin/sh

. ../scripts/lib/docker_run.sh

img_name='serverperf/springboot'
container_name='server_perf_springboot_native'

start_cmd="java -jar target/springboot-1.0-SNAPSHOT.jar"

volumes="$shared_volume_base"

network="$network_native"

docker_run

#
# open ports that services are running on in container
#
sudo firewall-cmd --add-port=5070/tcp

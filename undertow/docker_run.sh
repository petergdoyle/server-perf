

#!/bin/sh

. ../scripts/lib/docker_run.sh


image_name='server-perf/undertow'
container_name='server_perf_undertow_native'

start_cmd='java -jar target/undertow-1.0-SNAPSHOT.jar'

volumes=""

network="$network_native"

docker_run

#
# open ports that services are running on in container
#
sudo firewall-cmd --add-port=5090/tcp

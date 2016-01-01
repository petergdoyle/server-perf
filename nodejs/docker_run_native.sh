#!/bin/sh

. ../scripts/lib/docker_run.sh

img_name='serverperf/nodejs'
container_name='server_perf_nodejs_native'

start_cmd="$supervisord_cmd"

volumes="$shared_volume_base"

networking="$networking_native"

docker_run

#
# native ports have to be allowed through the firewall individually,
# docker port-forwarding doesn't require this manual configuration,
# all ports exposed through docker containers are allow to pass
# through the firewall by default
#
# sudo firewall-cmd --add-forward-port=port=15020:proto=tcp:toport=5020
# sudo firewall-cmd --add-forward-port=port=15021:proto=tcp:toport=5021
# sudo firewall-cmd --add-forward-port=port=14200:proto=tcp:toport=4200

#
# open ports that services are running on in container
#
sudo firewall-cmd --add-port=5020/tcp
sudo firewall-cmd --add-port=5021/tcp
sudo firewall-cmd --add-port=4200/tcp

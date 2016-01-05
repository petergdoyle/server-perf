

#!/bin/sh

. ../scripts/lib/docker_run.sh


img_name='server-perf/tomcat'
container_name='server_perf_tomcat_native'

start_cmd='/tomcat/default/bin/catalina.sh run'

volumes=""

network="$network_native"

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
sudo firewall-cmd --add-port=5040/tcp

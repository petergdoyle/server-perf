
#!/bin/sh

. ../scripts/lib/docker_run.sh


image_name='server-perf/tomcat'
container_name='server_perf_tomcat'

shared_volume_1="$PWD/webapps:/tomcat/default/webapps"
port_map_1='0.0.0.0:5040:8080'
#port_map_2='0.0.0.0:10001:10001' #JMX rmi port client
#port_map_3='0.0.0.0:10002:10002' #JMX rmi port server
network_port_mapped="$port_map_1 \
-h $container_name'.dkr'"
network="$network_port_mapped"

start_cmd='/tomcat/default/bin/catalina.sh run'

#volumes="$shared_volume_base"

docker_run

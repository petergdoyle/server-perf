

img_name='serverperf/jetty'
container_name='server_perf_jetty'
shell_cmd='/bin/bash'
start_cmd='java \
    -Dcom.sun.management.jmxremote \
    -Dcom.sun.management.jmxremote.ssl=false \
    -Dcom.sun.management.jmxremote.authenticate=false \
    -Dcom.sun.management.jmxremote.local.only=false \
    -Dcom.sun.management.jmxremote.port=1099 \
-jar /jetty/default/start.jar OPTIONS=Server,jmx etc/jetty-jmx.xml etc/jetty.xml'
shared_volume_1="$PWD/base:/base"
port_map_1='0.0.0.0:5050:8080'
port_map_2='0.0.0.0:10001:1099'
daemon='-d'
transient='--rm'
mode=$daemon

docker stop $container_name && docker rm $container_name

docker_cmd="docker run $mode -ti \
  --name $container_name \
  -v $shared_volume_1 \
  -p $port_map_1 -p $port_map_2 \
  -h $container_name.dkr \
  $img_name \
  $start_cmd"

echo "running command... $docker_cmd"
eval $docker_cmd

sleep 3s

docker ps -a

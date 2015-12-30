

img_name='serverperf/springboot'
container_name='server_perf_springboot'
shell_cmd='/bin/bash'
start_cmd='/tomcat/default/bin/catalina.sh run'
shared_volume_1="$PWD/webapps:/tomcat/default/webapps"
port_map_1='0.0.0.0:5040:8080'
port_map_2='0.0.0.0:10001:10001' #JMX rmi port client
port_map_3='0.0.0.0:10002:10002' #JMX rmi port server
daemon='-d'
transient='--rm'
mode=$daemon

docker stop $container_name
docker rm $container_name

docker_cmd="docker run $mode -ti \
  --name $container_name \
  -v $shared_volume_1 \
  -p $port_map_1 -p $port_map_2 -p $port_map_3 \
  -h $container_name.dkr \
  $img_name \
  $start_cmd"

  echo "running command... $docker_cmd"
  eval $docker_cmd

  sleep 3s
  docker ps -a

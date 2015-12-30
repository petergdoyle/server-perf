

img_name='serverperf/springboot'
container_name='server_perf_springboot'
shell_cmd='/bin/bash'
docker_cmd='java -jar target/springboot-1.0-SNAPSHOT.jar'
port_map_1='0.0.0.0:5070:5070'
daemon='-d'
transient='--rm'
mode=$daemon

docker stop $container_name
docker rm $container_name

docker_cmd="docker run $mode -ti \
  --name $container_name \
  -p $port_map_1 \
  -h $container_name.dkr \
  $img_name \
  $start_cmd"

  echo "running command... $docker_cmd"
  eval $docker_cmd

  sleep 3s
  docker ps -a

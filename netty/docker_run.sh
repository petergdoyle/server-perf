

img_name='server-perf/netty'
container_name='server_perf_netty'
shell_cmd='/bin/bash'
start_cmd='java -jar target/TestBackend-0.0.1-SNAPSHOT.jar'
shared_volume_1="$PWD:/docker"
port_map_1='5060:5060'

docker stop $container_name && docker rm $container_name

docker_cmd="docker run -d -ti \
  --name $container_name \
  -v $shared_volume_1 \
  -p $port_map_1 \
  -h $container_name.dkr \
  $img_name \
  $start_cmd"

  echo "running command... $docker_cmd"
  eval $docker_cmd

  sleep 3s
  docker ps -a

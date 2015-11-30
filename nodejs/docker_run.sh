
img_name='serverperf/nodejs'
container_name='server_perf_nodejs'
cmd='/usr/bin/supervisord -c /docker/supervisord.conf'
shared_volume_1="$PWD:/docker"
port_map_1='5020:5020'
port_map_2='4200:4200'

docker stop $container_name && docker rm $container_name

docker run -d -ti \
  --name $container_name \
  -v $shared_volume_1 \
  -p $port_map_1 -p $port_map_2 \
  -h $container_name.dkr \
  $img_name \
  $cmd

  docker ps -a

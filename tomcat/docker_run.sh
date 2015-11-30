

img_name='serverperf/tomcat'
container_name='server_perf_tomcat'
cmd='/tomcat/default/bin/catalina.sh run'
shared_volume_1="$PWD/webapps:/tomcat/default/webapps"
port_map_1='5040:8080'

docker stop $container_name && docker rm $container_name

docker run -d -ti \
  --name $container_name \
  -v $shared_volume_1 \
  -p $port_map_1 \
  -h $container_name.dkr \
  $img_name \
  $cmd

  docker ps -a

#!/bin/sh

read -e -p "host: " -i "localhost" host

while true; do
echo -e "*** select the server *** \n\
1)nodejs(~async, express) 1 \n\
2)tomcat(sync) 2 \n\
3)tomcat(async) 3 \n\
4)jetty(sync) 4 \n\
5)jetty(async) 5 \n\
6)netty(~async) 6 \n\
7)nodejs(~async, http) 7 \n\
8)springboot(sync, tomcat) 8 \n\
9)undertow(~async http) 9 \
"
read opt

case $opt in
    1) #nodejs
    port='5020'; context='/nodejs'; service='/perf'; server_type='nodejs_express'
    break
    ;;
    2) #tomcat sync servlet
    port='5040'; context='/servlet'; service='/perf'; server_type='tomcat_sync'
    break
    ;;
    3) #tomcat async servlet
    port='5040'; context='/servlet'; service='/perf/async'; server_type='tomcat_async'
    break
    ;;
    4) #jetty sync servlet
    port='5050'; context='/servlet'; service='/perf'; server_type='jetty_sync'
    break
    ;;
    5) #jetty async servlet
    port='5050'; context='/servlet'; service='/perf/async'; server_type='jetty_async'
    break
    ;;
    6) #netty
    port='5060'; context='/'; service=''; server_type='netty'
    break
    ;;
    7) #nodejs without express
    port='5021'; context='/'; service=''; server_type='nodejs_http'
    break
    ;;
    8) #nodejs without express
    port='5070'; context='/springboot/perf'; service=''; server_type='springboot_tomcat'
    break
    ;;
    9) #nodejs without express
    port='5090'; context='/'; service=''; server_type='undertow_http'
    break
    ;;
    *)
    echo "invalid option"
    ;;
esac
done


while true; do
echo -e "*** select the perf environment *** \n\
1)docker 1 \n\
2)docker native 2 \n\
3)vm 3 \n\
4)host 4 \
"
read opt

case $opt in
    1)
    env_type='docker'
    port='1'$port  #docker port forwarding adds a 1 to the front of the container default port / native portserver_type
    break
    ;;
    2)
    env_type='docker_native'
    break
    ;;
    3)
    env_type='vm'
    port='2'$port  #docker port forwarding adds a 2 to the front of the container default port / native port
    break
    ;;
    4)
    env_type='host' #docker container ports are exposed directly using docker_native or host implies the server is running on the host natively but the same port as would be taken by the docker_native container
    break
    ;;
    *)
    echo "invalid option"
    ;;
esac

done


target_url='http://'$host:$port$context$service

first_param_set=true
read -e -p "Sleep time: " -i "0" sleep_time
if [ "$sleep_time" -gt "0" ]; then
  target_url=$target_url'?sleep='$sleep_time
  first_param_set=false
fi
read -e -p "Response Body size: " -i "0" size
if [ "$size" -gt "0" ]; then
  if [ "$first_param_set" = true ]; then
    target_url=$target_url'?size='$size
    first_param_set=false
  else
    target_url=$target_url'&size='$size
  fi
fi

response_code=$(curl --write-out %{http_code} --silent --output /dev/null $target_url)
if [ "$response_code" -ne "200" ]; then
  echo "bad url specified as $target_url. server returned $response_code. cannot continue";
  exit $response_code
fi

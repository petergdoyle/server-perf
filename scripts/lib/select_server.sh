#!/bin/sh

read -e -p "host: " -i "localhost" host

while true; do
echo -e "*** select the server *** \n\
1)nodejs(~async, express) 1 \n\
2)tomcat(sync) 2 \n\
3)tomcat(async) 3 \n\
4)jetty(sync) 4 \n\
5)jetty(async) 5 \n\
6)netty(~async) 6 \n "
read opt

#5)spring(async) 5 \n\
#6)jaxrs(async) 6 \n\

case $opt in
    1) #nodejs
    port='5020'; context='/nodejs'; service='/perf'; server_type='nodejs_express'
    break
    ;;
    2) #tomcat sync servlet
    port='5040'; context='/servlet'; service='/perf/sync'; server_type='tomcat_sync'
    break
    ;;
    3) #tomcat async servlet
    port='5040'; context='/servlet'; service='/perf/async'; server_type='tomcat_async'
    break
    ;;
    4) #jetty sync servlet
    port='5050'; context='/servlet'; service='/perf/sync'; server_type='jetty_sync'
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
read -e -p "Response Body size: " -i "0" response_body_size
if [ "$response_body_size" -gt "0" ]; then
  if [ "$first_param_set" = true ]; then
    target_url=$target_url'?size='$response_body_size
    first_param_set=false
  else
    target_url=$target_url'&size='$response_body_size
  fi
fi

response_code=$(curl --write-out %{http_code} --silent --output /dev/null $target_url)
if [ "$response_code" -ne "200" ]; then 
  echo "bad url specified as $target_url. server returned $response_code. cannot continue"; 
  return $response_code
fi

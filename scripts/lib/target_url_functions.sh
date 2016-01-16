#!/bin/sh

build_target_url() {

  read -e -p "host: " -i "localhost" host

  while true; do
  echo -e "*** select the server *** \n\
   1) nodejs (express server) \n\
   2) nodejs (http server) \n\
   3) nodejs (http clustered server) \n\
   4) tomcat servlet container (sync servlet 2.5) \n\
   5) tomcat servlet container (async servlet 3.0 async execution / sync io ) \n\
   6) tomcat servlet container (async servlet 3.0 async execution / async io ) \n\
   7) jetty servlet container (sync servlet 2.5) \n\
   8) jetty servlet container (async servlet 3.0 async execution / sync io ) \n\
   9) jetty servlet container (async servlet 3.0 async execution / async io ) \n\
  10) springboot (mvc-rest, embedded tomcat) \n\
  11) springboot (mvc-rest, embedded undertow) \n\
  12) undertow (async http server) \n\
  13) apache httpd (php server) \n\
  14) nginx http (static html server) \n\
  15) netty http server \n\
  99) ** adhoc ** \
  "
  read opt

  case $opt in
      1) #nodejs
      port='5020'; context='/nodejs'; service='/perf'; server_type='nodejs_express'
      break
      ;;
      2) #nodejs
      port='5021'; context='/'; service=''; server_type='nodejs_http'
      break
      ;;
      3) #nodejs
      port='5022'; context='/'; service=''; server_type='nodejs_http_clustered'
      break
      ;;
      4) #tomcat sync servlet
      port='5040'; context='/servlet'; service='/perf'; server_type='tomcat_sync_servlet'
      break
      ;;
      5) #tomcat async servlet
      port='5040'; context='/servlet'; service='/perf/async'; server_type='tomcat_async_servlet_3_0'
      break
      ;;
      6) #tomcat async servlet
      port='5040'; context='/servlet'; service='/perf/async/io'; server_type='tomcat_async_servlet_3_1'
      break
      ;;
      7) #jetty sync servlet
      port='5050'; context='/servlet'; service='/perf'; server_type='jetty_sync_servlet'
      break
      ;;
      8) #jetty async servlet
      port='5050'; context='/servlet'; service='/perf/async'; server_type='jetty_async_servlet_3_0'
      break
      ;;
      9) #jetty async servlet
      port='5050'; context='/servlet'; service='/perf/async/io'; server_type='jetty_async_servlet_3_1'
      break
      ;;
      10)
      port='5070'; context='/springboot'; service='/perf'; server_type='springboot_mvc_tomcat'
      break
      ;;
      11)
      port='5072'; context='/springboot'; service='/perf'; server_type='springboot_mvc_undertow'
      break
      ;;
      12)
      port='5090'; context='/'; service=''; server_type='undertow_http'
      break
      ;;
      13)
      port='5010'; context='/'; service='/php/echo.php'; server_type='apache_httpd_php'
      break
      ;;
      14)
      port='5000'; context='/'; service=''; server_type='nginx_http'
      break
      ;;
      15)
      port='5060'; context='/'; service=''; server_type='netty_http'
      break
      ;;
      99)
      read -e -p "port: " -i "localhost" port
      read -e -p "context: " -i "/" context
      read -e -p "service: " -i "" service
      read -e -p "service type (label, common name, etc.): " -i "my service" server_type
      server_type=$(echo $server_type | xargs) # replace multiple spaces with single
      server_type=${server_type// /_} # replace spaces with underscores
      server_type=${server_type,,} # replace uppercase with lowercase
      break
      ;;
      *)
      echo "invalid option"
      ;;
  esac
  done

  while true; do
  echo -e "*** select the perf environment *** \n\
  1) docker port-mapped network \n\
  2) docker native network \n\
  3) vm \n\
  4) host \n\
  5) unknown \
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
      5)
      env_type='unknown' #docker container ports are exposed directly using docker_native or host implies the server is running on the host natively but the same port as would be taken by the docker_native container
      break
      ;;
      *)
      echo "invalid option"
      ;;
  esac
  done

  target_url='http://'$host:$port$context$service
}

#
# inputs: target_url
# ouputs: pattern
#
select_pattern() {

  target_url=$1

  while true; do
  echo -e "*** select a service pattern *** \n\
  1) raw response rate \n\
  2) echo (server upload download capability)
  3) timed latency (server request scalability) \n\
  4) cpu load (server request scalability) \n\
  5) download (server io output capability) \n\
  6) upload (server io input capability) \
  "
    read opt

    _first_param_set=true

    case $opt in
        1)
        _pattern='raw'
        break
        ;;
        2)
        _pattern='echo'
        # add in post elements here - like the file to upload or accept text to upload
        break
        ;;
        3)
        _pattern='timed_latency'
        read -e -p "Sleep time: " -i "0" _sleep_time
        if [ "$_sleep_time" -gt "0" ]; then
          if [ "$_first_param_set" = true ]; then
            target_url=$target_url'?sleep='$_sleep_time
          else
            target_url=$target_url'&sleep='$_sleep_time
            _first_param_set=false
          fi
        fi
        break
        ;;
        4)
        _pattern='cpu_load'
        break
        ;;
        5)
        _pattern='io_upload'
        break
        ;;
        5)
        _pattern='io_download'
        read -e -p "Response Body size: " -i "0" _size
        if [ "$_size" -gt "0" ]; then
          if [ "$_first_param_set" = true ]; then
            target_url=$target_url'?size='$_size
            _first_param_set=false
          else
            target_url=$target_url'&size='$_size
          fi
        fi
        break
        ;;
        *)
        echo "invalid option"
        ;;
    esac
  done

}

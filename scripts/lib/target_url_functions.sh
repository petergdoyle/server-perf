#!/bin/sh

build_target_url() {

  read -e -p "Target server (hostname): " -i "localhost" host

  while true; do
  echo -e "*** select the server type *** \n\
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
  16) nodejs (express clustered server) \n\
  17) go (golang http server) \n\
  99) ** adhoc ** \
  "
  read opt

  case $opt in
      1) #nodejs
      protocol='http://' port='5020'; target_uri='/nodejs/perf'; server_type='nodejs_express'
      break
      ;;
      2) #nodejs
      protocol='http://' port='5021'; target_uri='/'; server_type='nodejs_http'
      break
      ;;
      3) #nodejs
      protocol='http://' port='5022'; target_uri='/'; server_type='nodejs_http_clustered'
      break
      ;;
      4) #tomcat sync servlet
      protocol='http://' port='5040'; target_uri='/servlet/perf'; server_type='tomcat_sync_servlet'
      break
      ;;
      5) #tomcat async servlet
      protocol='http://' port='5040'; target_uri='/servlet/perf/async'; server_type='tomcat_async_servlet_3_0'
      break
      ;;
      6) #tomcat async servlet
      protocol='http://' port='5040'; target_uri='/servlet/perf/async/io'; server_type='tomcat_async_servlet_3_1'
      break
      ;;
      7) #jetty sync servlet
      protocol='http://' port='5050'; target_uri='/servlet/perf'; server_type='jetty_sync_servlet'
      break
      ;;
      8) #jetty async servlet
      protocol='http://' port='5050'; target_uri='//perf/async'; server_type='jetty_async_servlet_3_0'
      break
      ;;
      9) #jetty async servlet
      protocol='http://' port='5050'; target_uri='/servlet/perf/async/io'; server_type='jetty_async_servlet_3_1'
      break
      ;;
      10)
      protocol='http://' port='5070'; target_uri='/springboot/perf'; server_type='springboot_mvc_tomcat'
      break
      ;;
      11)
      protocol='http://' port='5072'; target_uri='/springboot/perf'; server_type='springboot_mvc_undertow'
      break
      ;;
      12)
      protocol='http://' port='5090'; target_uri='/'; server_type='undertow_http'
      break
      ;;
      13)
      pprotocol='http://' ort='5010'; target_uri='/php/echo.php'; server_type='apache_httpd_php'
      break
      ;;
      14)
      protocol='http://' port='5000'; target_uri='/'; server_type='nginx_http'
      break
      ;;
      15)
      protocol='http://' port='5060'; target_uri='/'; server_type='netty_http'
      break
      ;;
      16)
      protocol='http://' port='5023'; target_uri='/nodejs/perf'; server_type='nodejs_express_clustered'
      break
      ;;
      17)
      protocol='http://' port='6000'; target_uri='/'; server_type='golang_http'
      break
      ;;
      99)
      read -e -p "protocol: " -i "http://" protocol
      read -e -p "port: " -i "80" port
      read -e -p "uri: " -i "/" target_uri
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
  echo -e "*** select the perf environment (on server) *** \n\
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

  if [[ "$protocol" == 'http://' && "$port" == '80' ]] || [[ "$protocol" == 'https://' && "$port" == '443' ]]; then
    target_url=$protocol$host$target_uri
  else
    target_url=$protocol$host':'$port$target_uri
  fi
}

#
# inputs: target_url
# ouputs: pattern
#
select_service_pattern() {

  target_url=$1

  while true; do
  echo -e "*** select a service pattern *** \n\
  1) ping (speed test) \n\
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
        service_pattern='ping_pattern'
        service_pattern_details='_'$service_pattern
        break
        ;;
        2)
        service_pattern='echo_pattern'
        # add in post elements here - like the file to upload or accept text to upload
        break
        ;;
        3)
        service_pattern='timed_latency_pattern'
        read -e -p "Sleep time: " -i "0" _sleep_time
        if [ "$_sleep_time" -gt "0" ]; then
          if [ "$_first_param_set" = true ]; then
            target_url=$target_url'?sleep='$_sleep_time
          else
            target_url=$target_url'&sleep='$_sleep_time
            _first_param_set=false
          fi
        fi
        service_pattern_details='_'$service_pattern'_sleep_'$_sleep_time
        break
        ;;
        4)
        service_pattern='cpu_load_pattern'
        break
        ;;
        5)
        service_pattern='io_upload_pattern'
        break
        ;;
        5)
        service_pattern='io_download_pattern'
        read -e -p "Response Body size: " -i "0" _download_size
        if [ "$_download_size" -gt "0" ]; then
          if [ "$_first_param_set" = true ]; then
            target_url=$target_url'?size='$_download_size
            _first_param_set=false
          else
            target_url=$target_url'&size='$_download_size
          fi
        fi
        service_pattern_details='_'$service_pattern'_size_'$_download_size
        break
        ;;
        *)
        echo "invalid option"
        ;;
    esac
  done

}

veryify_target_url() {
  target_url=$1
  validate_service_url $target_url #make sure the server is up and service is available
  while [ $? -ne 0 ]; do
    build_target_url
  done
}

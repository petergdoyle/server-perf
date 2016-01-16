#!/bin/sh
. ../scripts/lib/target_url_functions.sh
. ../scripts/lib/select_dry_run.sh
. ../scripts/lib/display_countdown.sh
. ../scripts/lib/color_and_format_functions.sh
. ../scripts/lib/network_functions.sh


build_target_url
select_pattern $target_url
validate_service_url $target_url
if [ $? -ne 0 ]; then
  exit
fi

#
# httpress <options> <url>
#    -n num   number of requests     (default: 1)
#    -t num   number of threads      (default: 1)
#    -c num   concurrent connections (default: 1)
#    -k       keep alive             (default: no)
#    -q       no progress indication (default: no)
#    -z pri   GNUTLS cipher priority (default: NORMAL)
#    -h       show this help
#
# example: httpress -n 10000 -c 100 -t 4 -k http://localhost:8080/index.html
#
read -e -p "Enter the number of concurrent connections: " -i "1000" number_of_concurrent_connections
read -e -p "Enter the total number of requests: " -i "100000" total_number_of_requests
read -e -p "Enter the number of threads (1-4): " -i "4" number_of_threads
read -e -p "Run connection keep-alive (y/n): " -i "y" connection_keep_alive_response

read -e -p "Enter the number of executions executions: " -i "5" executions
if [ "$executions" -gt 1 ]; then
  read -e -p "Enter sleep time between executions(in minutes): " -i "3" shell_sleep_time
fi

default_log_file=$PWD'/httpress/httpress_c'$number_of_concurrent_connections'_n'$total_number_of_requests'_'$host'_'$env_type'_'$server_type'_sleep_'$sleep_time'ms_response_body_size_'$response_body_size'b.out'
read -e -p "Enter execution log file location/name: " -i "$default_log_file" log_file
if [ -f "$log_file" ]; then
  echo "A file with that name already exists. Either change it or it will be overwritten."
  read -e -p "Enter siege log file location/name: " -i "$log_file" log_file
fi


enable_http_keep_alive='-k'
if [ "$connection_keep_alive_response" != "y" ]; then
  enable_http_keep_alive=""
fi

for i in $(eval echo "{1..$executions"}); do
  cmd="httpress $enable_http_keep_alive -t $number_of_threads -n $total_number_of_requests -c $number_of_concurrent_connections $target_url"
  echo $cmd
  eval $cmd
  if [ "$i" -lt "$executions" ]; then
    echo 'done.'
    show_countdown $shell_sleep_time 'next siege'
  fi
done

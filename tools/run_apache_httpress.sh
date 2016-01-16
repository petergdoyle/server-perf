#!/bin/sh
. ../scripts/lib/select_server.sh
. ../scripts/lib/select_dry_run.sh
. ../scripts/lib/display_countdown.sh

# sample to put 100000 requests over 1000 connections
# ab -r -n 100000 -c 1000 http://engine2:5020/nodejs/perf
#
read -e -p "Enter the number of concurrent requests: " -i "1000" number_of_concurrent_requests
read -e -p "Enter the total number of requests: " -i "100000" total_number_of_requests
read -e -p "Run connection keep-alive (y/n): " -i "y" connection_keep_alive


read -e -p "Enter the number of executions executions: " -i "5" executions
read -e -p "Enter sleep time between executions(in minutes): " -i "3" shell_sleep_time

default_log_file=$PWD'/apache_bench/apache_bench_c'$number_of_concurrent_requests'_n'$total_number_of_requests'_'$host'_'$env_type'_'$server_type'_sleep_'$sleep_time'ms_response_body_size_'$response_body_size'b.out'
read -e -p "Enter execution log file location/name: " -i "$default_log_file" log_file
if [ -f "$log_file" ]; then
  echo "A file with that name already exists. Either change it or it will be overwritten."
  read -e -p "Enter siege log file location/name: " -i "$log_file" log_file
fi


dont_exit_on_socket_receive_errors='-r'
enable_http_keep_alive='-k'
if [ "$enable_http_keep_alive" != "y" ]; then
  enable_http_keep_alive=""
fi

for i in $(eval echo "{1..$executions"}); do
  cmd="ab $dont_exit_on_socket_receive_errors $enable_http_keep_alive -n $total_number_of_requests -c $number_of_concurrent_requests $target_url"
  eval $cmd
  if [ "$i" -lt "$repetitions" ]; then
    echo 'done.'
    show_countdown $shell_sleep_time 'next siege'
  fi
done

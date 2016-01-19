#!/bin/sh
. ../scripts/lib/target_url_functions.sh
. ../scripts/lib/select_dry_run.sh
. ../scripts/lib/display_countdown.sh
. ../scripts/lib/color_and_format_functions.sh
. ../scripts/lib/network_functions.sh
. ../scripts/lib/benchmark_functions.sh

#
# select target server/service and service-pattern
#
benchmark_tool=$1
build_target_url
select_service_pattern $target_url
validate_service_url $target_url #make sure the server is up and service is available
if [ $? -ne 0 ]; then
  exit
fi

#
# sample to put 100000 requests over 1000 connections
# ab -r -n 100000 -c 1000 http://engine2:5020/nodejs/perf
#
read -e -p "Enter the number of concurrent requests: " -i "1000" number_of_concurrent_requests
read -e -p "Enter the total number of requests: " -i "100000" total_number_of_requests
read -e -p "Run connection keep-alive (y/n): " -i "y" connection_keep_alive

dont_exit_on_socket_receive_errors='-r'

if [ "$connection_keep_alive" != "y" ]; then
  enable_http_keep_alive=""
else
  enable_http_keep_alive='-k'
fi

cmd="ab $dont_exit_on_socket_receive_errors $enable_http_keep_alive -n $total_number_of_requests -c $number_of_concurrent_requests $target_url"
run_benchmark "$cmd"

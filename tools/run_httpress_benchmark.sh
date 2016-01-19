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
read -e -p "Enter number of threads (1-$number_of_cores): " -i "$number_of_cores" number_of_threads
read -e -p "Run connection keep-alive (y/n): " -i "y" connection_keep_alive_response
if [ "$connection_keep_alive_response" != "y" ]; then
  enable_http_keep_alive=""
else
  enable_http_keep_alive='-k'
fi

cmd="httpress $enable_http_keep_alive -t $number_of_threads -n $total_number_of_requests -c $number_of_concurrent_connections $target_url"
run_benchmark "$cmd"

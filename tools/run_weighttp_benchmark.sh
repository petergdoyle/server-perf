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
# weighttp <options> <url>
#  -n num   number of requests    (mandatory)
#  -t num   threadcount           (default: 1)
#  -c num   concurrent clients    (default: 1)
#  -k       keep alive            (default: no)
#  -6       use ipv6              (default: no)
#  -H str   add header to request
#  -h       show help and exit
#  -v       show version and exit
#
# example: weighttp -c 10 -n 1000 -t 2 -k http://localhost:5000/
#

read -e -p "Enter number of Requests: " -i "100000" number_of_requests
read -e -p "Enter number of concurrent clients (>1): " -i "1000" number_of_connections
number_of_cores=$(grep -c ^processor /proc/cpuinfo)
read -e -p "Enter number of threads: " -i "$number_of_cores" number_of_threads
read -e -p "Keep alive (y/n) " -i "y" keep_alive_response
if [ "$keep_alive_response" != "y" ]; then
  keep_alive=""
else
  keep_alive="-k"
fi

cmd='weighttp -c '$number_of_connections' -n '$number_of_requests' -t '$number_of_threads' '$keep_alive' '$target_url
run_benchmark "$cmd"

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
# Usage: wrk <options> <url>
#  Options:
#    -c, --connections <N>  Connections to keep open
#    -d, --duration    <T>  Duration of test
#    -t, --threads     <N>  Number of threads to use
#
#    -s, --script      <S>  Load Lua script file
#    -H, --header      <H>  Add header to request
#        --latency          Print latency statistics
#        --timeout     <T>  Socket/request timeout
#    -v, --version          Print version details
#
#  Numeric arguments may include a SI unit (1k, 1M, 1G)
#  Time arguments may include a time unit (2s, 2m, 2h)
#
read -e -p "Enter number of connections: " -i "1000" number_of_connections
read -e -p "Enter duration of test(seconds): " -i "60" duration_of_test
number_of_cores=$(grep -c ^processor /proc/cpuinfo)
read -e -p "Enter number of threads (1-$number_of_cores): " -i "$number_of_cores" number_of_threads
read -e -p "Print latency statistics (y/n) " -i "y" print_latency_response
if [ "$print_latency_response" != "y" ]; then
  print_latency=""
else
  print_latency="--latency"
fi

cmd='wrk -c '$number_of_connections' -d '$duration_of_test's -t '$number_of_threads' '$print_latency' '$target_url
run_benchmark "$cmd" "$duration_of_test"

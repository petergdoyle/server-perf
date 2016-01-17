#!/bin/sh
. ../scripts/lib/target_url_functions.sh
. ../scripts/lib/select_dry_run.sh
. ../scripts/lib/display_countdown.sh
. ../scripts/lib/color_and_format_functions.sh
. ../scripts/lib/network_functions.sh

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

read -e -p "Enter number of connections: " -i "1000" number_of_connections
read -e -p "Enter duration of test: " -i "60s" duration_of_test
number_of_cores=$(grep -c ^processor /proc/cpuinfo)
read -e -p "Enter number of threads: " -i "$number_of_cores" number_of_threads
read -e -p "Print latency statistics (y/n) " -i "y" print_latency_response
if [ "$print_latency_response" != "y" ]; then
  print_latency=""
else
  print_latency="--latency"
fi

read -e -p "Enter sleep time between executions(in minutes): " -i "3" shell_sleep_time
read -e -p "Enter number of executions: " -i "5" executions
default_log_file=$PWD'/wrk/wrk_'$host'_'$env_type'_'$server_type'_sleep_'$sleep_time'ms_size_'$size'b.csv'
read -e -p "Enter execution log file location/name: " -i "$default_log_file" log_file

timeout_time=`expr $duration_of_test \* 3`

for i in $(eval echo "{1..$executions"}); do
    timestamp=$(date +%Y-%m-%d:%H:%M:%S)
    cmd='timeout '$timeout_time's wrk -c '$number_of_connections' -d '$duration -t $number_of_threads $print_latency $target_url
    eval "$cmd"
    if [ "$i" -lt "$executions" ]; then
      echo "done. sleeping $shell_sleep_time..."
      cmd="show_countdown $shell_sleep_time 'next execution'"
      eval $cmd
    fi
done

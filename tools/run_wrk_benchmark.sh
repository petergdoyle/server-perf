#!/bin/sh
. ../scripts/lib/target_url_functions.sh
. ../scripts/lib/select_dry_run.sh
. ../scripts/lib/display_countdown.sh
. ../scripts/lib/color_and_format_functions.sh
. ../scripts/lib/network_functions.sh

#
# select target server/service and service-pattern
#
build_target_url
select_service_pattern $target_url
validate_service_url $target_url
if [ $? -ne 0 ]; then
  exit
fi

#
# tool specific features
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
read -e -p "Enter number of threads: " -i "$number_of_cores" number_of_threads
read -e -p "Print latency statistics (y/n) " -i "y" print_latency_response
if [ "$print_latency_response" != "y" ]; then
  print_latency=""
else
  print_latency="--latency"
fi

#
# execution options
#
read -e -p "Enter sleep time between executions(in minutes): " -i "3" shell_sleep_time
read -e -p "Enter number of executions: " -i "5" executions

#
# set up location to redirect sysout
#
default_log_file=$PWD'/wrk/wrk_'$host'_'$env_type'_'$server_type$service_pattern_details'.out'
read -e -p "Enter log file location/name: " -i "$default_log_file" log_file
if [ -f "$log_file" ]; then
  echo "A file with that name already exists. Either change it or it will be overwritten."
  read -e -p "Enter log file location/name: " -i "$log_file" log_file
fi
if [ -f "$log_file" ]; then
  rm -v $log_file
fi

#
# execute all these tools with a timeout as sometimes they don't stop running
#
timeout_time=`expr $duration_of_test \* 3`
cmd='(timeout '$timeout_time's wrk -c '$number_of_connections' -d '$duration_of_test's -t '$number_of_threads' '$print_latency' '$target_url' >> '$log_file') &'

#
# execute the benchmark as many times as requested
#
for i in $(eval echo "{1..$executions"}); do

    timestamp=$(date +%Y-%m-%d:%H:%M:%S)
    echo "running benchmark $i of $executions on $target_url at $timestamp..."
    echo -e "\nBenchmark: $i\nCommand: $cmd\nTime: $timestamp" >> $log_file
    #echo "$cmd"
    eval "$cmd"
    show_spinner $!

    if [ "$i" -lt "$executions" ]; then
      echo 'done. sleeping '$shell_sleep_time'm...'
      show_countdown $shell_sleep_time 'next execution'
    fi

done

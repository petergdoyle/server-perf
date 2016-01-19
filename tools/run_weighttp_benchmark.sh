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
# weighttp <options> <url>
#  -n num   number of requests (mandatory)
#  -t num   threadcount (default: 1)
#  -c num   concurrent clients (default: 1)
#  -k       keep alive (default: no)
#  -h       show help and exit
#  -v       show version and exit
#
#

read -e -p "Enter number of Requests: " -i "100000" number_of_requests
read -e -p "Enter number of concurrent clients: " -i "1000" number_of_connections
number_of_cores=$(grep -c ^processor /proc/cpuinfo)
read -e -p "Enter number of threads: " -i "$number_of_cores" number_of_threads
read -e -p "Keep alive (y/n) " -i "y" keep_alive_response
if [ "$keep_alive_response" != "y" ]; then
  keep_alive=""
else
  keep_alive="-k"
fi

#
# execution options
#
read -e -p "Enter sleep time between executions(in minutes): " -i "3" shell_sleep_time
read -e -p "Enter number of executions: " -i "5" executions

#
# set up location to redirect stdout
#
default_log_file=$PWD'/weighttp/weighttp_'$host'_'$env_type'_'$server_type$service_pattern_details'.out'
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
#timeout_time=`expr $duration_of_test \* 3`
cmd='(timeout 30s weighttp -c '$number_of_connections' -n '$number_of_requests' -t '$number_of_threads' '$keep_alive' '$target_url' >> '$log_file') &'

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
    else
      echo 'done. results of benchmark are located in '$log_file
    fi

done

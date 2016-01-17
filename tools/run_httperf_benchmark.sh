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
# httperf --hog --timeout=5 --client=0/1 --server=engine2 --port=5040 --uri=/servlet/perf --rate=500 --send-buffer=4096 --recv-buffer=1024 --num-conns=5000 --num-calls=10
#

read -e -p "Enter the connection rate (#/sec.): " -i "500" conn_rate
read -e -p "Enter the total number of connections: " -i "3000" num_conns
read -e -p "Enter the number of calls per connection: " -i "1000" num_calls_per_conn

server_timeout=5

read -e -p "Enter the number of executions executions: " -i "5" executions
if [ "$executions" -gt 1 ]; then
  read -e -p "Enter sleep time between executions(in minutes): " -i "3" shell_sleep_time
fi

default_log_file=$PWD'/httperf/httperf_conn_rate_'$conn_rate'_num_conns_'$num_cons'_'$host'_'$env_type'_'$server_type'_sleep_'$sleep_time'ms_response_body_size_'$response_body_size'b.out'
read -e -p "Enter execution log file location/name: " -i "$default_log_file" log_file
if [ -f "$log_file" ]; then
  echo "A file with that name already exists. Either change it or it will be overwritten."
  read -e -p "Enter log file location/name: " -i "$log_file" log_file
fi

for i in $(eval echo "{1..$executions"}); do
  cmd="httperf --hog --timeout=5 --client=0/1 --server=$host --port=$port --uri=$context$service --rate=$conn_rate --send-buffer=4096 --recv-buffer=1024 --num-conns=$num_conns --num-calls=$num_calls_per_conn"
  eval $cmd
  if [ "$i" -lt "$executions" ]; then
    echo 'done.'
    show_countdown $shell_sleep_time 'next siege'
  fi
done

#!/bin/sh

default_siege_time='60'
read -e -p "Enter siege time on the server: " -i "$default_siege_time" siege_time

default_timeout_time=`expr $siege_time \* 3`
read -e -p "Enter default siege maximum run time: " -i "$default_timeout_time" timeout_time

default_shell_sleep_time='5m'
read -e -p "Enter sleep time between sieges: " -i "$default_shell_sleep_time" shell_sleep_time

default_repetitions='5'
read -e -p "Enter number of siege repetitions: " -i "$default_repetitions" repetitions

default_log_file='siege_'$host'_'$server_type'_sleep_'$sleep_time'ms_response_body_size_'$response_body_size'b.csv'
read -e -p "Enter siege log file location/name: " -i "$default_log_file" log_file

if [ -f $log_file ]; then
  rm $log_file
fi
for i in $(eval echo "{1..$repetitions"}); do
    timestamp=$(date +%Y-%m-%d:%H:%M:%S)
    echo "running siege $i of $repetitions on $target_url at $timestamp..."
    #timeout $timeout_time's' siege -b 't'$siege_time's' $target_url
    echo "done. sleeping $shell_sleep_time..."
    #sleep $shell_sleep_time
done
if [ -f ~/siege.log ]; then
  cp ~/siege.log $log_file
fi

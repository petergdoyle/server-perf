#!/bin/sh
. ../scripts/lib/select_server.sh

default_siege_time='60'
read -e -p "Enter siege time on the server(in seconds): " -i "$default_siege_time" siege_time

default_timeout_time=`expr $siege_time \* 3`
read -e -p "Enter default siege maximum run time(in seconds): " -i "$default_timeout_time" timeout_time

default_shell_sleep_time='3'
read -e -p "Enter sleep time between sieges(in minutes): " -i "$default_shell_sleep_time" shell_sleep_time

default_repetitions='5'
read -e -p "Enter number of siege repetitions: " -i "$default_repetitions" repetitions

default_log_file=$PWD'/siege/siege_'$host'_'$env_type'_'$server_type'_sleep_'$sleep_time'ms_size_'$size'b.csv'
read -e -p "Enter siege log file location/name: " -i "$default_log_file" log_file

if [ -f ~/siege.log ]; then
  rm ~/siege.log
fi

if [ -f $log_file ]; then
  rm $log_file
fi

for i in $(eval echo "{1..$repetitions"}); do
    timestamp=$(date +%Y-%m-%d:%H:%M:%S)
    echo "running siege $i of $repetitions on $target_url at $timestamp..."
    cmd="timeout $timeout_time"'s siege -b -t'"$siege_time"'s'" $target_url"
    echo $cmd
    eval $cmd
    if [ "$i" -lt "$repetitions" ]; then
      echo "done. sleeping $shell_sleep_time..."
      sleep $shell_sleep_time'm'
    fi
done

cp ~/siege.log $log_file

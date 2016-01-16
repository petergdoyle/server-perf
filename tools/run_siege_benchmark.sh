#!/bin/sh
. ../scripts/lib/target_url_functions.sh
. ../scripts/lib/select_dry_run.sh
. ../scripts/lib/display_countdown.sh
. ../scripts/lib/color_and_format_functions.sh


build_target_url
select_pattern $target_url
validate_target_url $target_url

export SIEGERC=$PWD/siegerc

if ! [ -f $SIEGERC ]; then
  echo "configuration file missing. cannot continue"
  exit 1
fi

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
if [ -f "$log_file" ]; then
  echo "A file with that name already exists. Either change it or it will be overwritten."
  read -e -p "Enter siege log file location/name: " -i "$log_file" log_file
fi

if [ -f ~/siege.log ]; then
  cmd='rm '"~/siege.log"
  if [ -n "$dryrun" ]; then
    echo "$cmd"
  else
    eval "$cmd"
  fi
fi

for i in $(eval echo "{1..$repetitions"}); do
    timestamp=$(date +%Y-%m-%d:%H:%M:%S)
    cmd='timeout '$timeout_time's siege -b -t '$siege_time's '$target_url
    if [ -n "$dryrun" ]; then
      echo "$cmd"
    else
      echo "running siege $i of $repetitions on $target_url at $timestamp..."
      echo "$cmd"
      eval "$cmd"
    fi
    if [ "$i" -lt "$repetitions" ]; then
      echo 'done. start sleeping for '$shell_sleep_time' m...'
      #cmd='sleep '$shell_sleep_time'm'
      cmd="show_countdown $shell_sleep_time 'next siege'"
      if [ -n "$dryrun" ]; then
        echo "$cmd"
      else
        eval "$cmd"
      fi
    fi
done

cmd='cp ~/siege.log '$log_file
if [ -n "$dryrun" ]; then
  echo "$cmd"
else
  eval "$cmd"
fi

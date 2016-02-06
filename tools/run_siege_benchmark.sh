#!/bin/sh
. ../scripts/lib/target_url_functions.sh
. ../scripts/lib/select_dry_run.sh
. ../scripts/lib/display_countdown.sh
. ../scripts/lib/color_and_format_functions.sh
. ../scripts/lib/network_functions.sh
. ../scripts/lib/benchmark_functions.sh
. ../scripts/lib/filesystem_functions.sh


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

export SIEGERC=$PWD/siegerc

if ! [ -f $SIEGERC ]; then
  echo "configuration file missing. cannot continue"
  exit 1
fi

read -e -p "Enter siege time on the server(in seconds): " -i "60" siege_time
default_timeout_time=`expr $siege_time \* 3`
read -e -p "Enter the maximum run time(in seconds): " -i "$default_timeout_time" timeout_time

#siege doensn't let you specify it's own log file location (or the "-l" parameter doesn't work correctly)
if [ -f ~/siege.log ]; then
  cmd='rm '"~/siege.log"
  if [ -n "$dryrun" ]; then
    echo "$cmd"
  else
    eval "$cmd"
  fi
fi

cmd='timeout '$timeout_time's siege -b -t '$siege_time's '$target_url
run_benchmark "$cmd"

#use the same sysout log file name and switch the file extension so the names match
siege_log_file=$(change_file_ext $log_file '.log')

cmd='cp ~/siege.log '$siege_log_file
if [ -n "$dryrun" ]; then
  echo "$cmd"
else
  eval "$cmd"
fi

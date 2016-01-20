#!/bin/sh


number_of_cores=$(grep -c ^processor /proc/cpuinfo)

run_benchmark() {

  cmd=$1
  read -e -p "Benchmark command (confirm): " -i "$cmd" cmd
  duration_of_test=$2

  #
  # execution options
  #
  read -e -p "Enter the number of executions executions: " -i "5" executions
  if [ "$executions" -gt 1 ]; then
    read -e -p "Enter sleep time between executions(in minutes): " -i "3" shell_sleep_time
  fi

  #
  # set up location to redirect stdout
  #
  default_log_file_name=$PWD'/'$benchmark_tool'/'$benchmark_tool'_'$server_type'_'$host'_'$env_type$service_pattern_details
  default_log_file=$default_log_file_name'.out'
  read -e -p "Enter log file location/name: " -i "$default_log_file" log_file
  if [ -f "$log_file" ]; then
    echo "A file with that name already exists. Either change the or it will be overwritten."
    read -e -p "Confirm/Re-enter log file location/name: " -i "$log_file" log_file
  fi
  if [ -f "$log_file" ]; then
    rm -v $log_file
  fi

  #
  # execute all these tools with a timeout as sometimes they don't stop running
  #
  re='^[0-9]+$'
  if ! [[ $duration_of_test =~ $re ]]; then #if not specfied or specified is not a number
    timeout_time='30'
  else
    timeout_time=`expr $duration_of_test \* 3`
  fi
  #cmd='(timeout '$timeout_time's wrk -c '$number_of_connections' -d '$duration_of_test's -t '$number_of_threads' '$print_latency' '$target_url' >> '$log_file') &'
  cmd_orig=$cmd
  cmd='('$cmd' >> '$log_file') &'

  #
  # execute the benchmark as many times as requested
  #
  for i in $(eval echo "{1..$executions"}); do

      timestamp=$(date +%Y-%m-%d:%H:%M:%S)
      echo "running $benchmark_tool benchmark $i of $executions at $timestamp..."
      echo -e "\nBenchmark: $i\nCommand: $cmd_orig\nTime: $timestamp" >> $log_file
      eval "$cmd"
      show_spinner $!

      if [ "$i" -lt "$executions" ]; then
        echo 'done. sleeping '$shell_sleep_time'm...'
        show_countdown $shell_sleep_time 'next execution'
      else
        echo 'done. output from benchmark is located in '$log_file
      fi

  done

}

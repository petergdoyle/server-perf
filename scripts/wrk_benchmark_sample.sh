#!/bin/sh
. lib/network_functions.sh

read -e -p "Target server (hostname): " -i "localhost" host
read -e -p "Enter number of connections: " -i "1000" connections
read -e -p "Enter duration of test(seconds): " -i "60" runtime
number_of_cores=$(grep -c ^processor /proc/cpuinfo)
read -e -p "Enter number of threads (1-$number_of_cores): " -i "$number_of_cores" threads
read -e -p "Enter number of bytes to retreive from server (download pattern): " -i "10000" size

out="~/wrk_benchmark_sample_download_pattern_"$size"kb.out"

if [ -f $out ]; then
  rm $out
fi

#catalina+servlet-2.5
wrk -c $connections -d $runtime-t $threads --latency http://$host:5040/servlet/perf/async?size=$size >> $out
wait_for_socket_waits_to_clear
#catalina+async-servlet-30
wrk -c $connections -d $runtime-t $threads --latency http://$host:5040/servlet/perf?size=$size >> $out
wait_for_socket_waits_to_clear
#netty
wrk -c $connections -d $runtime-t $threads --latency http://$host:5060/netty/download?size=$size >> $out
wait_for_socket_waits_to_clear
#nodejs+expressjs
wrk -c $connections -d $runtime-t $threads --latency http://$host:5020/nodejs/perf?size=$size >> $out
wait_for_socket_waits_to_clear
#nodejs+expressjs+cluster
wrk -c $connections -d $runtime-t $threads --latency http://$host:5023/nodejs/perf?size=$size >> $out

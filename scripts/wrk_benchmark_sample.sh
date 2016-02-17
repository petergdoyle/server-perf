#!/bin/sh
. lib/network_functions.sh
. lib/display_countdown.sh

read -e -p "Target server (ip): " -i "localhost" host
ip=$(getent hosts $host| awk '{ print $1 }')
read -e -p "Enter number of connections: " -i "1000" connections
read -e -p "Enter duration of test(seconds): " -i "60" run_time
number_of_cores=$(grep -c ^processor /proc/cpuinfo)
read -e -p "Enter number of threads (1-$number_of_cores): " -i "$number_of_cores" threads
read -e -p "Enter number of bytes to retreive from server (download pattern): " -i "10000" size

out="./wrk_benchmark_sample_download_pattern_"$size"kb.out"

if [ -f $out ]; then
  rm $out
fi

wait_for_socket_waits_to_clear $ip

#catalina+servlet-2.5
cmd="wrk -c $connections -d $run_time -t $threads --latency http://$host:5040/servlet/perf/async?size=$size"
cmd_orig=$cmd
cmd='('$cmd' >> '$out') &'
echo "executing command $cmd_orig"
eval "$cmd"
show_spinner $!
echo "waiting for sockets to clear..."
wait_for_socket_waits_to_clear $ip
#catalina+async-servlet-30
cmd="wrk -c $connections -d $run_time -t $threads --latency http://$host:5040/servlet/perf?size=$size"
cmd_orig=$cmd
cmd='('$cmd' >> '$out') &'
echo "executing command $cmd_orig"
eval "$cmd"
show_spinner $!
echo "waiting for sockets to clear..."
wait_for_socket_waits_to_clear $ip
#netty
cmd="wrk -c $connections -d $run_time -t $threads --latency http://$host:5060/netty/download?size=$size"
cmd_orig=$cmd
cmd='('$cmd' >> '$out') &'
echo "executing command $cmd_orig"
eval "$cmd"
show_spinner $!
echo "waiting for sockets to clear..."
wait_for_socket_waits_to_clear $ip
#nodejs+expressjs
cmd="wrk -c $connections -d $run_time -t $threads --latency http://$host:5020/nodejs/perf?size=$size"
cmd_orig=$cmd
cmd='('$cmd' >> '$out') &'
echo "executing command $cmd_orig"
eval "$cmd"
show_spinner $!
echo "waiting for sockets to clear..."
wait_for_socket_waits_to_clear $ip
#nodejs+expressjs+cluster
cmd="wrk -c $connections -d $run_time -t $threads --latency http://$host:5023/nodejs/perf?size=$size >>"
cmd_orig=$cmd
cmd='('$cmd' >> '$out') &'
echo "executing command $cmd_orig"
eval "$cmd"
show_spinner $!
echo "waiting for sockets to clear..."
wait_for_socket_waits_to_clear $ip

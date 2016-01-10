
. ../scripts/lib/select_server.sh

# sample to put 100000 requests over 1000 connections
# ab -r -n 100000 -c 1000 http://engine2:5020/nodejs/perf
#

while [[ -z "$number_of_concurrent_requests" ]]
do
  echo -n "Enter Number of concurrent requests : "
  read number_of_concurrent_requests
done

while [[ -z "$total_number_of_requests" ]]
do
  echo -n "Enter the Number of requests to perform for the benchmarking session. "
  read total_number_of_requests
done


default_log_file=$PWD'/apache_bench/apache_bench_c'$number_of_concurrent_requests'_n'$total_number_of_requests'_'$host'_'$env_type'_'$server_type'_sleep_'$sleep_time'ms_response_body_size_'$response_body_size'b.out'
read -e -p "Enter siege log file location/name: " -i "$default_log_file" log_file

dont_exit_on_socket_receive_errors='-r'
enable_http_keep_alive='-k'

run_apache_bench() {
  cmd="ab $dont_exit_on_socket_receive_errors $enable_http_keep_alive -n $total_number_of_requests -c $number_of_concurrent_requests $target_url"
  echo "running... $cmd"
  eval $cmd
}

run_apache_bench

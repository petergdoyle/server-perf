
. ../scripts/lib/select_server.sh

while [[ -z "$c_param" ]]
do
  echo -n "Enter Number of concurrent requests : "
  read c_param
done

while [[ -z "$n_param" ]]
do
  echo -n "Enter the Number of requests to perform for the benchmarking session. "
  read n_param
done

run_apache_bench() {
  cmd="ab -r -n $n_param -c $c_param $target_url"
  echo "running... $cmd"
  eval $cmd
}

run_apache_bench

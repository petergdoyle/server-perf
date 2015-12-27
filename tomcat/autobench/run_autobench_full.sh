
dryrun=$1

for param in "$@"
do
    if [ $param = "--dry-run" ]; then
      dryrun='--dry-run'
    fi
done


# low_rate, high_rate, rate_step
# The 'rate' is the number of number of connections to open per second.
# A series of tests will be conducted, starting at low rate,
# increasing by rate step, and finishing at high_rate.
# The default settings test at rates of 20,30,40,50...180,190,200

low_rate='100'
high_rate='500'
rate_step='100'

# num_conn, num_call
# num_conn is the total number of connections to make during a test
# num_call is the number of requests per connection
# The product of num_call and rate is the the approximate number of
# requests per second that will be attempted.

num_conn='5000'
num_call='10'

#
# --low_rate 20 --high_rate 40 --rate_step 5 --num_call 10 --num_conn 5000
#
# Regardless of the rate, autobench will make num_conn connections per test. As rate increases, the duration per test decreases.
#
# num_conn specifies the number of connections that will be made. (5000)
#
# num_call specifies the number of calls (requests) per connection. (10)
#
# rate specifies the number of connections per second. (20 initially)
#
# So the total number of requests in a test is: num_conn * num_call (50000)
#
# The duration of a test is: num_conn / rate (250 seconds initially)
#
# The (attempted) requests per second in a test is: num_call * rate (200 initially)
#

# timeout sets the maximimum time (in seconds) that httperf will wait
# for replies from the web server.  If the timeout is exceeded, the
# reply concerned is counted as an error.

timeout='5'

# ? change the default num_call value from 10 to 1 (num_call specifies the
# number of HTTP requests per connection; set it to 1 to keep things
# simple). ex If you start load runs with low_rate set to 10, high_rate set to 50
# and rate_step set to 10. What this means is that autobench will run httperf 5
# times, starting with 10 requests/sec and going up to 50 requests/sec in
# increments of 10.

host1='engine2'
ip1='192.168.1.82'
port1='5040'
container_name='server_perf_servlet'
if [ -z $dryrun ]; then
  shell_sleep_time='5m' # Waits 5 minutes.
else
  shell_sleep_time='2s'
fi

run_autobench() {
 cmd="autobench --single_host \
    --host1=$host1 --port1=$port1 --uri1=$uri1 \
    --low_rate $low_rate --high_rate $high_rate --rate_step $rate_step \
    --num_call $num_call --num_conn $num_conn \
    --timeout $timeout \
    --file $file.tsv"
  echo $cmd
  if [ -z $dryrun ]; then
    eval $cmd
  fi
}




### ### ### ### ### ### ### ###
###
### increased io
###
### ### ### ### ### ### ### ###
sleep='0'
size='0'
netstat -anl | grep $ip1 | awk '/^tcp/ {t[$NF]++}END{for(state in t){print state, t[state]} }'
uri1='"/servlet/perf"'; file=$(echo ${host1}'_'$container_name'_sync_size_'${size}'k_sleep_'${sleep}'ms');
run_autobench
sleep $shell_sleep_time

size='1000'
netstat -anl | grep $ip1 | awk '/^tcp/ {t[$NF]++}END{for(state in t){print state, t[state]} }'
uri1="\"/servlet/perf?size=${size}\""; file=$(echo ${host1}'_'$container_name'_sync_size_'${size}'k_sleep_'${sleep}'ms');
run_autobench
sleep $shell_sleep_time

size='10000'
netstat -anl | grep $ip1 | awk '/^tcp/ {t[$NF]++}END{for(state in t){print state, t[state]} }'
uri1="\"/servlet/perf?size=${size}\""; file=$(echo ${host1}'_'$container_name'_sync_size_'${size}'k_sleep_'${sleep}'ms');
run_autobench
sleep $shell_sleep_time

size='100000'
netstat -anl | grep $ip1 | awk '/^tcp/ {t[$NF]++}END{for(state in t){print state, t[state]} }'
uri1="\"/servlet/perf?size=${size}\""; file=$(echo ${host1}'_'$container_name'_sync_size_'${size}'k_sleep_'${sleep}'ms');
run_autobench
sleep $shell_sleep_time

size='1000000'
netstat -anl | grep $ip1 | awk '/^tcp/ {t[$NF]++}END{for(state in t){print state, t[state]} }'
uri1="\"/servlet/perf?size=${size}\""; file=$(echo ${host1}'_'$container_name'_sync_size_'${size}'k_sleep_'${sleep}'ms');
run_autobench
sleep $shell_sleep_time


netstat -anl | grep $ip1 | awk '/^tcp/ {t[$NF]++}END{for(state in t){print state, t[state]} }'
uri1='"/servlet/perf/async"'; file=$(echo ${host1}'_'$container_name'_async_size_'${size}'k_sleep_'${sleep}'ms');
run_autobench
sleep $shell_sleep_time

size='1000'
netstat -anl | grep $ip1 | awk '/^tcp/ {t[$NF]++}END{for(state in t){print state, t[state]} }'
uri1="\"/servlet/perf/async?size=${size}\""; file=$(echo ${host1}'_'$container_name'_async_size_'${size}'k_sleep_'${sleep}'ms');
run_autobench
sleep $shell_sleep_time

size='10000'
netstat -anl | grep $ip1 | awk '/^tcp/ {t[$NF]++}END{for(state in t){print state, t[state]} }'
uri1="\"/servlet/perf/async?size=${size}\""; file=$(echo ${host1}'_'$container_name'_async_size_'${size}'k_sleep_'${sleep}'ms');
run_autobench
sleep $shell_sleep_time

size='100000'
netstat -anl | grep $ip1 | awk '/^tcp/ {t[$NF]++}END{for(state in t){print state, t[state]} }'
uri1="\"/servlet/perf/async?size=${size}\""; file=$(echo ${host1}'_'$container_name'_async_size_'${size}'k_sleep_'${sleep}'ms');
run_autobench
sleep $shell_sleep_time

size='1000000'
netstat -anl | grep $ip1 | awk '/^tcp/ {t[$NF]++}END{for(state in t){print state, t[state]} }'
uri1="\"/servlet/perf/async?size=${size}\""; file=$(echo ${host1}'_'$container_name'_async_size_'${size}'k_sleep_'${sleep}'ms');
run_autobench
sleep $shell_sleep_time



### ### ### ### ### ### ### ###
###
### increased latency
###
### ### ### ### ### ### ### ###
timeout='90'

size='0'
sleep='1000'
netstat -anl | grep $ip1 | awk '/^tcp/ {t[$NF]++}END{for(state in t){print state, t[state]} }'
uri1="\"/servlet/perf?sleep=${sleep}\""; file=$(echo ${host1}'_'$container_name'_sync_size_'${size}'k_sleep_'${sleep}'ms');
run_autobench
sleep $shell_sleep_time

sleep='2500'
netstat -anl | grep $ip1 | awk '/^tcp/ {t[$NF]++}END{for(state in t){print state, t[state]} }'
uri1="\"/servlet/perf?sleep=${sleep}\""; file=$(echo ${host1}'_'$container_name'_sync_size_'${size}'k_sleep_'${sleep}'ms');
run_autobench
sleep $shell_sleep_time

sleep='5000'
netstat -anl | grep $ip1 | awk '/^tcp/ {t[$NF]++}END{for(state in t){print state, t[state]} }'
uri1="\"/servlet/perf?sleep=${sleep}\""; file=$(echo ${host1}'_'$container_name'_sync_size_'${size}'k_sleep_'${sleep}'ms');
run_autobench
sleep $shell_sleep_time

sleep='25000'
netstat -anl | grep $ip1 | awk '/^tcp/ {t[$NF]++}END{for(state in t){print state, t[state]} }'
uri1="\"/servlet/perf?sleep=${sleep}\""; file=$(echo ${host1}'_'$container_name'_sync_size_'${size}'k_sleep_'${sleep}'ms');
run_autobench
sleep $shell_sleep_time

size='0'
sleep='1000'
netstat -anl | grep $ip1 | awk '/^tcp/ {t[$NF]++}END{for(state in t){print state, t[state]} }'
uri1="\"/servlet/perf/async?sleep=${sleep}\""; file=$(echo ${host1}'_'$container_name'_async_size_'${size}'k_sleep_'${sleep}'ms');
run_autobench
sleep $shell_sleep_time

sleep='2500'
netstat -anl | grep $ip1 | awk '/^tcp/ {t[$NF]++}END{for(state in t){print state, t[state]} }'
uri1="\"/servlet/perf/async?sleep=${sleep}\""; file=$(echo ${host1}'_'$container_name'_async_size_'${size}'k_sleep_'${sleep}'ms');
run_autobench
sleep $shell_sleep_time

sleep='5000'
netstat -anl | grep $ip1 | awk '/^tcp/ {t[$NF]++}END{for(state in t){print state, t[state]} }'
uri1="\"/servlet/perf/async?sleep=${sleep}\""; file=$(echo ${host1}'_'$container_name'_async_size_'${size}'k_sleep_'${sleep}'ms');
run_autobench
sleep $shell_sleep_time

sleep='25000'
netstat -anl | grep $ip1 | awk '/^tcp/ {t[$NF]++}END{for(state in t){print state, t[state]} }'
uri1="\"/servlet/perf/async?sleep=${sleep}\""; file=$(echo ${host1}'_'$container_name'_async_size_'${size}'k_sleep_'${sleep}'ms');
run_autobench
sleep $shell_sleep_time

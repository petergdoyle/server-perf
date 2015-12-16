

# low_rate, high_rate, rate_step
# The 'rate' is the number of number of connections to open per second.
# A series of tests will be conducted, starting at low rate,
# increasing by rate step, and finishing at high_rate.
# The default settings test at rates of 20,30,40,50...180,190,200

low_rate='20'
high_rate='200'
rate_step='10'

# num_conn, num_call
# num_conn is the total number of connections to make during a test
# num_call is the number of requests per connection
# The product of num_call and rate is the the approximate number of
# requests per second that will be attempted.

num_conn='5000'
num_call='10'

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
port1='5040'

run_autobench() {
  autobench --single_host \
    --host1=$host1 --port1=$port1 --uri1=$uri1 \
    --low_rate $low_rate --high_rate $high_rate --rate_step $rate_step \
    --num_call $num_call --num_conn $num_conn \
    --timeout $timeout \
    --file $file
}


shell_sleep_time='5m' # Waits 5 minutes.


### ### ### ### ### ### ### ###
###
### increased io
###
### ### ### ### ### ### ### ###
sleep='0'
size='0'
uri1='"/servlet/perf"'; file=$(echo ${host1}'_server_perf_tomcat_sync_size_'${size}'k_sleep_'${sleep}'ms.tsv'); run_autobench
sleep $shell_sleep_time
uri1='"/servlet/perf/async"'; file=$(echo ${host1}'_server_perf_tomcat_async_size_'${size}'k_sleep_'${sleep}'ms.tsv'); run_autobench
sleep $shell_sleep_time

size='1000'
uri1="\"servlet/perf?size=${size}\""; file=$(echo ${host1}'_server_perf_tomcat_sync_size_'${size}'k_sleep_'${sleep}'ms.tsv'); run_autobench
sleep $shell_sleep_time
uri1="\"servlet/perf?size=${size}\""; file=$(echo ${host1}'_server_perf_tomcat_async_size_'${size}'k_sleep_'${sleep}'ms.tsv'); run_autobench
sleep $shell_sleep_time

size='10000'
uri1="\"servlet/perf?size=${size}\""; file=$(echo ${host1}'_server_perf_tomcat_sync_size_'${size}'k_sleep_'${sleep}'ms.tsv'); run_autobench
sleep $shell_sleep_time
uri1="\"servlet/perf?size=${size}\""; ile=$(echo ${host1}'_server_perf_tomcat_async_size_'${size}'k_sleep_'${sleep}'ms.tsv'); run_autobench
sleep $shell_sleep_time

size='100000'
uri1="\"servlet/perf?size=${size}\""; file=$(echo ${host1}'_server_perf_tomcat_sync_size_'${size}'k_sleep_'${sleep}'ms.tsv'); run_autobench
sleep $shell_sleep_time
uri1="\"servlet/perf?size=${size}\""; file=$(echo ${host1}'_server_perf_tomcat_async_size_'${size}'k_sleep_'${sleep}'ms.tsv'); run_autobench
sleep $shell_sleep_time

size='1000000'
uri1="\"servlet/perf?size=${size}\""; file=$(echo ${host1}'_server_perf_tomcat_sync_size_'${size}'k_sleep_'${sleep}'ms.tsv'); run_autobench
sleep $shell_sleep_time
uri1="\"servlet/perf?size=${size}\""; file=$(echo ${host1}'_server_perf_tomcat_async_size_'${size}'k_sleep_'${sleep}'ms.tsv'); run_autobench
sleep $shell_sleep_time



### ### ### ### ### ### ### ###
###
### increased latency
###
### ### ### ### ### ### ### ###
timeout='15'

size='0'
sleep='1000'
uri1="\"servlet/perf?sleep=${sleep}\"";  file=$(echo ${host1}'_server_perf_tomcat_sync_size_'${size}'k_sleep_'${sleep}'ms.tsv'); run_autobench
sleep $shell_sleep_time
uri1="\"servlet/perf?sleep=${sleep}\""; file=$(echo ${host1}'_server_perf_tomcat_async_size_'${size}'k_sleep_'${sleep}'ms.tsv'); run_autobench
sleep $shell_sleep_time

sleep='2500'
uri1="\"servlet/perf?sleep=${sleep}\"";file=$(echo ${host1}'_server_perf_tomcat_sync_size_'${size}'k_sleep_'${sleep}'ms.tsv'); run_autobench
sleep $shell_sleep_time
uri1="\"servlet/perf?sleep=${sleep}\""; file=$(echo ${host1}'_server_perf_tomcat_async_size_'${size}'k_sleep_'${sleep}'ms.tsv'); run_autobench
sleep $shell_sleep_time

sleep='5000'
uri1="\"servlet/perf?sleep=${sleep}\""; file=$(echo ${host1}'_server_perf_tomcat_sync_size_'${size}'k_sleep_'${sleep}'ms.tsv'); run_autobench
sleep $shell_sleep_time
uri1="\"servlet/perf?sleep=${sleep}\""; file=$(echo ${host1}'_server_perf_tomcat_async_size_'${size}'k_sleep_'${sleep}'ms.tsv'); run_autobench
sleep $shell_sleep_time

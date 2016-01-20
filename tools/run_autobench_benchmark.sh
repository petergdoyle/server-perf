#!/bin/sh
. ../scripts/lib/target_url_functions.sh
. ../scripts/lib/select_dry_run.sh
. ../scripts/lib/display_countdown.sh
. ../scripts/lib/color_and_format_functions.sh
. ../scripts/lib/network_functions.sh
. ../scripts/lib/benchmark_functions.sh

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

# low_rate, high_rate, rate_step
# The 'rate' is the number of number of connections to open per second.
# A series of tests will be conducted, starting at low rate,
# increasing by rate step, and finishing at high_rate.
# The default settings test at rates of 20,30,40,50...180,190,200

low_rate='100'
high_rate='1200'
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

echo "autobench will increase load using httperf..."
echo "'rate' is the total number of connections to make per second."
read -e -p "Enter the low connection rate: " -i "$low_rate" low_rate
read -e -p "Enter the high connection rate: " -i "$high_rate" high_rate
read -e -p "Enter the connection step-rate: " -i "$rate_step" rate_step
read -e -p "Enter the total number of connections to make: " -i "$num_conn" num_conn
read -e -p "Enter the number of requests per connection: " -i "$num_call" num_call
read -e -p "Enter the maximum response time(in seconds): " -i "5" max_response_time

cmd="autobench --single_host \
  --host1=$host --port1=$port --uri1=$target_uri \
  --low_rate $low_rate --high_rate $high_rate --rate_step $rate_step \
  --num_call $num_call --num_conn $num_conn \
  --timeout $max_response_time \
  --file $default_log_file_name.tsv"

run_benchmark "$cmd"

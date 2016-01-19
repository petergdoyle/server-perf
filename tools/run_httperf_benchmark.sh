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

#
# EXAMPLES
#       httperf --hog --server www
#              This command causes httperf to create a connection to host www, send a request for the root document (http://www/), receive the reply, close the connection, and then print some performance statistics.
#
#       httperf --hog --server www --num-conn 100 --ra 10 --timeout 5
#              Like above, except that a total of 100 connections are created and that connections are created at a fixed rate of 10 per second.  Note that option ``--rate'' has been abbreviated to ``--ra''.
#
#       httperf --hog --server=www --wsess=10,5,2 --rate 1 --timeout 5
#              Causes httperf to generate a total of 10 sessions at a rate of 1 session per second.  Each session consists of 5 calls that are spaced out by 2 seconds.
#
#       httperf --hog --server=www --wsess=10,5,2 --rate=1 --timeout=5 --ssl
#              Like above, except that httperf contacts server www via SSL at port 443 (the default port for SSL connections).
#
#       httperf --hog --server www --wsess=10,5,2 --rate=1 --timeout=5 --ssl --ssl-ciphers=EXP-RC4-MD5:EXP-RC2-CBC-MD5 --ssl-no-reuse --http-version=1.0
#              Like  above,  except  that  httperf will inform the server that it can only select from two cipher suites (EXP-RC4-MD5 or EXP-RC2-CBC-MD5); furthermore, httperf will use HTTP version 1.0 which requires a new TCP connection for each request.
#              Also, SSL session ids are not reused, so the entire SSL connection establishment process (known as the SSL handshake) occurs for each connection.
#
# OPTIONS (many more these are the ones supported here)
#       --think-timeout=X
#              Specifies the maximum time that the server may need to initiate sending the reply for a given request.  Note that this timeout value is added to the normal timeout value (see option --timeout).  When accessing static web content, it is usu‐
#              ally not necessary to specify this option.  However, when performing tests with long-running CGI scripts, it may be necessary to use this option to allow for larger response-times.  The default value for this option is zero seconds, meaning
#              that the server has to be able to respond within the normal timeout value.
#
#       --hog  This  option  requests to use up as many TCP ports as necessary.  Without this option, httperf is typically limited to using ephemeral ports (in the range from 1024 to 5000).  This limited port range can quickly become a bottleneck so it is
#              generally a good idea to specify this option for serious testing.  Also, this option must be specified when measuring NT servers since it avoids a TCP incompatibility between NT and UNIX machines.
#
#       --method=S
#              Specifies the method that should be used when issuing an HTTP request.  If this option is not specified, the GET method is used.  The method S can be an arbitrary string but is usually one of GET, HEAD, PUT, POST, etc.
#
#       --num-calls=N
#              This  option  is  meaningful  for  request-oriented workloads only.  It specifies the total number of calls to issue on each connection before closing it.  If N is greater than 1, the server must support persistent connections.  The default
#              value for this option is 1.  If --burst-length is set to B, then the N calls are issued in bursts of B pipelined calls each.  Thus, the total number of such bursts will be N/B (per connection).
#
#       --num-conns=N
#              This option is meaningful for request-oriented workloads only.  It specifies the total number of connections to create.  On each connection, calls are issued as specified by options --num-calls and --burst-length.  A test stops as  soon  as
#              the  N  connections  have either completed or failed.  A connection is considered to have failed if any activity on the connection fails to make forward progress for more than the time specified by the timeout options --timeout and --think-
#              timeout.  The default value for this option is 1.
#
#       --timeout=X
#              Specifies the amount of time X that httperf is willing to wait for a server reaction.  The timeout is specified in seconds and can be a fractional number (e.g., --timeout 3.5).  This timeout value is used when establishing a TCP connection,
#              when sending a request, when waiting for a reply, and when receiving a reply.  If during any of those activities a request fails to make forward progress within the alloted time, httperf considers the request to have died, closes the  asso‐
#              ciated connection or session and increases the client-timo error count.  The actual timeout value used when waiting for a reply is the sum of this timeout and the think-timeout (see option --think-timeout).  By default, the timeout value is
#              infinity.
#

read -e -p "Enter the connection rate (#/sec.): " -i "500" conn_rate
read -e -p "Enter the total number of connections: " -i "3000" num_conns
read -e -p "Enter the number of calls per connection: " -i "1000" num_calls_per_conn
read -e -p "Enter the maximum response time(in seconds): " -i "5" max_response_time

cmd="httperf --hog --timeout=$max_response_time --client=0/1 --server=$host --port=$port --uri=$context$service --rate=$conn_rate --send-buffer=4096 --recv-buffer=1024 --num-conns=$num_conns --num-calls=$num_calls_per_conn"
run_benchmark "$cmd"

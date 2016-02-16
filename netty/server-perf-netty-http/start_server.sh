#!/bin/sh

#
# usage: ./start_server.sh com.cleverfishsoftware.serverperf.netty.http1.EchoServer 5060
#

mainClass=$1
port=$2

java -cp .:target/server-perf-netty-http-1.0-SNAPSHOT.jar $mainClass $port

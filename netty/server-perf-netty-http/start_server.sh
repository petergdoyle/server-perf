#!/bin/sh

#
# usage: ./start_server com.cleverfishsoftware.serverperf.netty.http1.EchoServer 6666
#

mainClass=$1
port=$2

java -cp .:target/netty-http1-1.0-SNAPSHOT.jar $mainClass $port

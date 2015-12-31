#!/bin/sh

#cmd="netstat -anl | grep $ip | awk '/^tcp/ {t[\$NF]++}END{for(state in t){print state, t[state]} }'"
netstat -anl | grep $ip | awk '/^tcp/ {t[$NF]++}END{for(state in t){print state, t[state]} }'

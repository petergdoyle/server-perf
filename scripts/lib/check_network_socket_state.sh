#!/bin/sh

check_network_socket_state() {
  if [ -e $ip1 ]; then
    echo "variable ip1 is not set. cannot continue"
    return 1
  fi
  netstat -anl | grep $ip1 | awk '/^tcp/ {t[$NF]++}END{for(state in t){print state, t[state]} }'
}

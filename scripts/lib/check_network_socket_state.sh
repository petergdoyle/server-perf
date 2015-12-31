#!/bin/sh

ip=$1
if [ -n "$ip" ]; then
  echo "found"
else
  while [[ -z "$ip" ]]
  do
    echo -n "Enter remote ip to check connection state "
    read ip
  done
fi

. lib/check_network_socket_state.sh

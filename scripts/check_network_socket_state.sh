#!/bin/sh

ip=$1

  while [[ -z "$ip" ]]
  do
    echo -n "Enter remote ip to check connection state "
    read ip
  done

. ../scripts/lib/check_network_socket_state.sh

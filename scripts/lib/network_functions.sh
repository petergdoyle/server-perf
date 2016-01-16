#!/bin/sh

check_network_socket_state() {
  if [ -e $ip1 ]; then
    echo "variable ip1 is not set. cannot continue"
    return 1
  fi
  response=$(netstat -anl | grep $ip1 | awk '/^tcp/ {t[$NF]++}END{for(state in t){print state, t[state]} }')
  if [ "$response" == "" ]; then
    return 0
  else
    return 1
  fi
}

port_forward() {
  local port=$1
  local toport=$2 
  # native ports have to be allowed through the firewall individually,
  # docker port-forwarding doesn't require this manual configuration,
  # all ports exposed through docker containers are allow to pass
  # through the firewall by default
  #
  # sudo firewall-cmd --add-forward-port=port=15020:proto=tcp:toport=5020
  # sudo firewall-cmd --add-forward-port=port=15021:proto=tcp:toport=5021
  # sudo firewall-cmd --add-forward-port=port=14200:proto=tcp:toport=4200
}

open_firewall_port() {
  local ports=$1
  running=$(systemctl status firewalld |grep inactive)
  if [ "$running" != "" ]; then #exit if firewalld is not running
    echo $port |tr ',' '\n' |while read port; do #attempt to open each port specfied
      cmd="firewall-cmd --add-port=$port/tcp"
      if [ ! $( id -u ) -eq 0 ]; then #if not root user run sudo
        cmd="sudo $cmd"
      fi
      eval $cmd
    done
  fi
}

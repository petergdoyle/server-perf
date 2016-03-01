#!/bin/sh


check_network_socket_state() {
  local ip=$1
  if [ -e $ip ]; then
    echo "check_network_socket_state: variable ip is not set. cannot continue"
    return 1
  fi
  # the netstat command will return a summarized list of sockets in _WAIT state to a remote ip
  response=$(netstat -an | grep $ip | awk '/^tcp/ {t[$NF]++}END{for(state in t){print state, t[state]} }')
  if [ "$response" == "" ]; then
    return 0
  else
    echo $response
    return 1
  fi
}

watch_network_socket_state() {
  local ip=$1
  if [ -e $ip ]; then
    echo "watch_network_socket_state: variable ip is not set. cannot continue"
    return 1
  fi
  check_network_socket_state $ip
  while [ "$?" -ne "0" ]; do
    sleep 2
    check_network_socket_state $ip
  done
}

#
# adapted from
# Validating an IP Address in a Bash Script, Jun 26, 2008	 By Mitch Frazier
# http://www.linuxjournal.com/content/validating-ip-address-bash-script
#
function valid_ip() {
    local  ip=$1
    local  stat=1

    if [[ $ip =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
        OIFS=$IFS
        IFS='.'
        ip=($ip)
        IFS=$OIFS
        [[ ${ip[0]} -le 255 && ${ip[1]} -le 255 \
            && ${ip[2]} -le 255 && ${ip[3]} -le 255 ]]
        stat=$?
    fi
    return $stat
}

lookup_host_ip() {
  local host=$1
  if [ -e $host ]; then
    echo "variable host is not set. cannot continue"
    return 1
  fi
  valid_ip $host
  if [ "$?" -eq "0" ]; then
    ip=$host
  else
    ip=$(getent hosts $host| awk '{ print $1 }')
  fi
  echo $ip
}

wait_for_socket_waits_to_clear() {
  local ip=$1
  if [ -e $ip ]; then
    echo "variable ip is not set. cannot continue"
    return 1
  fi
  status=$(netstat -an|grep WAIT |grep $ip| wc -l)
  while [ "$status" -ne "0" ]
  do
    echo "waiting for $status connections in WAIT state to clear..."
    check_network_socket_state $ip
    sleep 10
    status=$(netstat -an|grep WAIT |grep $ip| wc -l)
  done
  echo "sockets cleared"
}

validate_service_url() {
  local url=$1
  if [ -e $url ]; then
    echo "variable url is not set. cannot continue"
    return 1
  fi
  response_code=$(curl --write-out %{http_code} --silent --output /dev/null $url)
  if [ "$response_code" -ne "200" ]; then
    echo "bad url specified as $url. server returned $response_code. check server or specify correct url. cannot continue";
    return 1
  else
    return 0
  fi
}


port_forward() {
  local port=$1
  local toport=$2
  #
  # native ports have to be allowed through the firewall individually,
  # docker port-forwarding doesn't require this manual configuration,
  # all ports exposed through docker containers are allow to pass
  # through the firewall by default
  #
  firewall-cmd --add-forward-port=port=$port:proto=tcp:toport=$toport
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

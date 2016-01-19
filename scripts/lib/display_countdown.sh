#!/bin/sh

#adapted from http://serverfault.com/questions/532559/bash-script-count-down-5-minutes-display-on-single-line

execute_after_countdown() {
  minutes=$1
  msg_prefix=$2
  function=$3
  secs=$(($minutes * 60))
  while [ $secs -gt 0 ]; do
     echo -ne $msg_prefix" in $secs seconds \033[K\r"
     sleep 1
     : $((secs--))
  done
  echo ""
  eval "$function"
}

show_countdown() {
  minutes=$1
  msg_prefix=$2
  secs=$(($minutes * 60))
  while [ $secs -gt 0 ]; do
     echo -ne $msg_prefix" in $secs seconds \033[K\r"
     sleep 1
     : $((secs--))
  done
  echo ""
}

show_params_and_variables() {
  compgen -v | while read line; do
    echo $line=${!line}
  done
}

# Credit Showing a Bash Spinner for Long Running Tasks
# by LOUIS MARASCIO on FEBRUARY 27, 2011
#
# usage:
#  execute the command in the background eg. (timeout 20s sleep 10s; echo "run1") &
#  then call the spinner with the last process pid spinner $!
#
show_spinner() {
  local pid=$1
  local delay=0.75
  local spinstr='|/-\'
  while [ "$(ps a | awk '{print $1}' | grep $pid)" ]; do
      local temp=${spinstr#?}
      printf " [%c]  " "$spinstr"
      local spinstr=$temp${spinstr%"$temp"}
      sleep $delay
      printf "\b\b\b\b\b\b"
  done
  printf "    \b\b\b\b"
}

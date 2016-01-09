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
  eval $function
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

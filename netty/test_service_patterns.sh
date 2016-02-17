#!/bin/sh


read -e -p "Target server (hostname): " -i "localhost" host
echo "$host"
port=5060

pattern='ping'
cmd="curl -i http://$host:5060/$pattern"
read -e -p "run $pattern pattern: " -i "$cmd" cmd
eval "$cmd"

pattern='echo'
cmd="curl -i -X \
POST -d $'Officia laborum aute veniam incididunt nostrud duis occaecat incididunt eu consectetur ullamco pariatur. Id dolor aliqua ullamco nostrud eiusmod laborum non do proident. Quis irure non deserunt velit deserunt elit cillum id excepteur ut exercitation commodo enim qui.\n' \
http://$host:5060/$pattern"
read -e -p "run $pattern pattern: " -i "$cmd" cmd
eval "$cmd"

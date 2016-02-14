#!/bin/sh


run_fast() {
  url=$1;
  end=$2;
  for i in $(eval echo "{1..$end"});   do
    curl -i -X \
    POST -d $'Officia laborum aute veniam incididunt nostrud duis occaecat incididunt eu consectetur ullamco pariatur. Id dolor aliqua ullamco nostrud eiusmod laborum non do proident. Quis irure non deserunt velit deserunt elit cillum id excepteur ut exercitation commodo enim qui.\n' \
    $url &
  done
  wait
}

# usage:
# run_fast 'http://localhost:6000/server-perf/upload?size=5400&sleep=300' 1
# "post content to the url 1 time"

time run_fast $1 $2

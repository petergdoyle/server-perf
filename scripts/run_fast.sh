#!/bin/sh


run_fast() {
  url=$1;
  reps=$2;

  read -e -p "view output (likely not if you are running a time command): " -i "y" view_output_response
  if [ "$view_output_response" == "y" ]; then
    curl_cmd="curl -i -X \
    POST -d $'Officia laborum aute veniam incididunt nostrud duis occaecat incididunt eu consectetur ullamco pariatur. Id dolor aliqua ullamco nostrud eiusmod laborum non do proident. Quis irure non deserunt velit deserunt elit cillum id excepteur ut exercitation commodo enim qui.\n' \
    $url"
  else
    curl_cmd="curl -s -X \
    POST -d $'Officia laborum aute veniam incididunt nostrud duis occaecat incididunt eu consectetur ullamco pariatur. Id dolor aliqua ullamco nostrud eiusmod laborum non do proident. Quis irure non deserunt velit deserunt elit cillum id excepteur ut exercitation commodo enim qui.\n' \
    $url  > /dev/null"
  fi

  for i in $(eval echo "{1..$reps"});   do
    eval $curl_cmd &
  done
  wait
}

# usage:
# run_fast 'http://localhost:6000/server-perf/upload?size=5400&sleep=300' 1
# "post content to the url 1 time"


run_fast $1 $2

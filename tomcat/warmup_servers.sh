


for i in {1..50}; do curl -i -X GET "http://localhost:5040/servlet/perf/async?sleep=500" & done; wait
for i in {1..50}; do curl -i -X GET "http://localhost:5040/servlet/perf?sleep=500" & done; wait

for i in {1..50}; do curl -i -X GET "http://localhost:5040/servlet/perf/async?size=500" & done; wait
for i in {1..50}; do curl -i -X GET "http://localhost:5040/servlet/perf?size=500" & done; wait



run_fast() {
  url=$1
  end=$2
  for i in $(eval echo "{1..$end"})
  do
    curl -i -X POST -d \
    $'Officia laborum aute veniam incididunt nostrud duis occaecat incididunt eu consectetur ullamco pariatur. Id dolor aliqua ullamco nostrud eiusmod laborum non do proident. Quis irure non deserunt velit deserunt elit cillum id excepteur ut exercitation commodo enim qui.\n' \
    $url &
  done
  wait
}

# example to time 5000 posts
time run_fast http://localhost:6060/ 5000

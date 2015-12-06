read -e -p "How many request: " -i "1" repetitions
read -e -p "Size of Response (bytes): " -i "0" size
read -e -p "Latency (millis): " -i "0" sleep
read -e -p "host: " -i "localhost" host
read -e -p "port: " -i "5040" port
read -e -p "context: " -i "servlet" context
read -e -p "service: " -i "TestServlet" service

for i in $(eval echo "{1..$repetitions"})
do
  curl -i -X GET "http://$host:$port/$context/$service?sleep=$sleep&size=$size" &
done

wait

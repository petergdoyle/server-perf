read -e -p "How many request:" -i "1" repetitions
read -e -p "Size of Response:" -i "0" size
read -e -p "Latency (in millis):" -i "0" sleep


for i in {1..$repetitions}
do
  curl -i -# -X GET "http://localhost:5040/servlets/TestServlet?sleep=$sleep&size=$size"
done

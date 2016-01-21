
while true; do
echo -e "*** select the server *** \n\
1)nodejs 1 \n\
2)tomcat(sync) 2 \n\
3)jetty(sync) 3 \n\
4)netty(async) 4 \n "
read opt

#5)spring(async) 5 \n\
#6)jaxrs(async) 6 \n\

case $opt in
    1)
    port='5020'; context='nodejs'; service='perf'
    break
    ;;
    2)
    port='5040'; context='servlet'; service='perf'
    break
    ;;
    3)
    port='5050'; context='servlet'; service='perf'
    break
    ;;
    *)
    echo "invalid option"
    ;;
esac
done

read -e -p "How many request: " -i "1" repetitions
read -e -p "Size of Response (bytes): " -i "0" size
read -e -p "Latency (millis): " -i "0" sleep
read -e -p "Async (y/n): " -i "n" async
read -e -p "host: " -i "localhost" host

cmd_part_1="curl -i -X GET \"http://$host:$port/$target_uri"
cmd_part_2=""
first=true
if [ $async == "y" ]; then
  cmd_part_1=$cmd_part_1"/async";
fi
#check sleep
if [ $sleep -gt 0 ]; then
  if [ "$first" = true ]; then
    cmd_part_2=$cmd_part_2"?";
    first=false
  else
    cmd_part_2=$cmd_part_2"&";
  fi
  cmd_part_2=$cmd_part_2"sleep=$sleep";
fi
#check size
if [ $size -gt 0 ]; then
  if [ "$first" = true ]; then
    cmd_part_2=$cmd_part_2"?";
    first=false
  else
    cmd_part_2=$cmd_part_2"&";
  fi
  cmd_part_2=$cmd_part_2"size=$size"
fi

cmd=$cmd_part_1$cmd_part_2"\""

read -e -p "Submit (y/n): $cmd " -i "y" submit

if [ "$submit" != 'y' ]; then
  exit 0;
fi

for i in $(eval echo "{1..$repetitions"})
do
  eval "$cmd" &
done
wait

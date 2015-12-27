
ip=$1
if [ -n "$ip" ]; then
  echo "found"
else
  while [[ -z "$ip" ]]
  do
    echo -n "Enter remote ip to check connection state "
    read ip
  done
fi

cmd="netstat -anl | grep $ip | awk '/^tcp/ {t[\$NF]++}END{for(state in t){print state, t[state]} }'"

echo "running $cmd..."

eval $cmd

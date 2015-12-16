
name='peter'
tag='cycling'

foo () {
 name=$1
 echo "$name $tag"
}

foo 'david'

echo "$name $tag"

tag='skiing'
foo 'peter'

host='localhost'

autobench() {
  echo -e "--single_host \
    --host1=$host1 --port1=$port1 --uri1=$uri1 \
    --low_rate $low_rate --high_rate $high_rate --rate_step $rate_step \
    --num_call $num_call --num_conn $num_conn \
    --timeout $timeout \
    --file $file"
}
sleep='2500'
size='10000'
uri1='"/servlet/perf"'; file=$(echo ${host}'_server_perf_tomcat_sync_size_'${size}'k_sleep_'${sleep}'ms.tsv'); autobench



siege_time='60'
timeout_time=`expr $siege_time \* 3`
shell_sleep_time='5m'
host='engine2'
port='5060'
uri='/'
repetitions='5'

rm ~/siege.log
rm siege.log
for i in $(eval echo "{1..$repetitions"}); do
    timestamp=$(date +%Y-%m-%d:%H:%M:%S)
    echo "running siege $i of $repetitions at $timestamp..."
    timeout $timeout_time's' siege -b 't'$siege_time's' http://$host:$port$uri
    echo "done. sleeping $shell_sleep_time..."
    sleep $shell_sleep_time
done
cp ~/siege.log ./siege.csv

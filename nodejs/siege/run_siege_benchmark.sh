

siege_time=60
timeout_time=`expr $siege_time \* 3`
shell_sleep_time='5m'
rm ~/siege.log
rm siege.log
for i in {1..5}; do
    timestamp=$(date +%Y-%m-%d:%H:%M:%S)
    echo "running siege $i at $timestamp..."
    timeout $timeout_time's' siege -b 't'$siege_time's' http://engine2:5020/nodejs/perf
    echo "done. sleeping $shell_sleep_time..."
    sleep $shell_sleep_time
done
cp ~/siege.log . 

#!/bin/sh

while true; do
echo -e "*** select a benchmark tool *** \n\
1) apache bench (ab) \n\
2) siege \n\
3) httpress \n\
4) httperf \n\
5) autobench (stepped load using httperf with aggregated results) \n\
6) weighttp \n\
7) wrk \
"
read opt

case $opt in
    1)
    benchmark_tool='ab'
    break
    ;;
    2)
    benchmark_tool='siege'
    break
    ;;
    3)
    benchmark_tool='httpress'
    break
    ;;
    4)
    benchmark_tool='httperf' #docker container ports are exposed directly using docker_native or host implies the server is running on the host natively but the same port as would be taken by the docker_native container
    break
    ;;
    5)
    benchmark_tool='autobench' #docker container ports are exposed directly using docker_native or host implies the server is running on the host natively but the same port as would be taken by the docker_native container
    break
    ;;
    6)
    benchmark_tool='weighttp' #docker container ports are exposed directly using docker_native or host implies the server is running on the host natively but the same port as would be taken by the docker_native container
    break
    ;;
    7)
    benchmark_tool='wrk' #docker container ports are exposed directly using docker_native or host implies the server is running on the host natively but the same port as would be taken by the docker_native container
    break
    ;;
    *)
    echo "invalid option"
    ;;
esac
done

_script_name='./run_'$benchmark_tool'_benchmark.sh'

eval $_script_name $benchmark_tool

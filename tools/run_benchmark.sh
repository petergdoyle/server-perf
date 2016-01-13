#!/bin/sh

while true; do
echo -e "*** select a benchmark tool *** \n\
1) apache bench (ab) \n\
2) siege \n\
3) httpress \n\
4) httperf \n\
5) autobench (stepped load using httperf with aggregated results) \n\
6) weighttp \
"
read opt

case $opt in
    1)
    tool='apache_bench'
    break
    ;;
    2)
    _tool='siege'
    break
    ;;
    3)
    _tool='httpress'
    break
    ;;
    4)
    _tool='httperf' #docker container ports are exposed directly using docker_native or host implies the server is running on the host natively but the same port as would be taken by the docker_native container
    break
    ;;
    5)
    _tool='autobench' #docker container ports are exposed directly using docker_native or host implies the server is running on the host natively but the same port as would be taken by the docker_native container
    break
    ;;
    6)
    _tool='weighttp' #docker container ports are exposed directly using docker_native or host implies the server is running on the host natively but the same port as would be taken by the docker_native container
    break
    ;;
    *)
    echo "invalid option"
    ;;
esac
done

_script_name='./run_'$_tool'_benchmark.sh'

eval $_script_name

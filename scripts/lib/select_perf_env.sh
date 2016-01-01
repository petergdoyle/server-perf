#!/bin/sh


while true; do
echo -e "*** select the perf environment *** \n\
1)docker 1 \n\
2)docker native 2 \n\
3)vm 3 \n\
4)host 4 \
"
read opt

case $opt in
    1)
    env_type='docker'
    port='1'$port  #docker port forwarding adds a 1 to the front of the container default port / native port
    break
    ;;
    2)
    env_type='docker_native'
    break
    ;;
    3)
    env_type='vm'
    break
    ;;
    4)
    env_type='host' #docker container ports are exposed directly using docker_native or host implies the server is running on the host natively but the same port as would be taken by the docker_native container
    break
    ;;
    *)
    echo "invalid option"
    ;;
esac

done


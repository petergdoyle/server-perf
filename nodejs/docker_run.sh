#!/bin/sh

img_name='serverperf/nodejs'
container_name='server_perf_nodejs'

start_cmd="$supervisord_cmd"

volumes="$shared_volume_base"

port_map_1='-p 0.0.0.0:15020:5020'
port_map_2='-p 0.0.0.0:15021:5021'
port_map_3='-p 0.0.0.0:14200:4200'

network="$port_map_1 $port_map_2 $port_map_3"

docker_run

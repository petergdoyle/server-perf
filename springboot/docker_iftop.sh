#!/bin/sh

. ../scripts/lib/docker_iftop.sh

container_name='server_perf_springboot'

docker_iftop

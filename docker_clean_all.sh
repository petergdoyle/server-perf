#!/bin/sh
. scripts/lib/docker_functions.sh

docker_remove_all_containers
docker_remove_all_images
docker_cleanup_dangling_images



docker_top() {
  docker exec -ti $container_name top -H -p 1
}

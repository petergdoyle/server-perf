
docker_build() {
  no_cache=$1

  if [ -e $img_name ]; then
    echo "variable img_name is not set. cannot continue"
    return 1
  fi
  if [ -n "$no_cache" ]; then echo "--no_cache"; else echo "cache"; fi

  docker build $no_cache -t=$img_name .

}

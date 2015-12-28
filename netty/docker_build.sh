
no_cache=$1
img_name='serverperf/netty'

if [ -n "$no_cache" ]; then echo "--no_cache"; else echo "cache"; fi

docker build $no_cache -t=$img_name .

docker images

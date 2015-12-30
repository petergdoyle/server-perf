
no_cache=$1
img_name='serverperf/springboot'

docker build $no_cache -t=$img_name .

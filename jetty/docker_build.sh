

no_cache=$1
img_name='serverperf/jetty'

docker build $no_cache -t=$img_name .

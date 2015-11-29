

docker stop server_perf_nodejs && docker rm server_perf_nodejs

docker run -d -ti \
  --name server_perf_nodejs \
  -v $PWD:/docker \
  -p 5020:5020 \
  -p 4200:4200 \
  -h server_perf_nodejs.dkr \
  serverperf/nodejs \
  /usr/bin/supervisord -c /docker/supervisord.conf

docker ps -a


docker stop server_perf_tomcat && docker rm server_perf_tomcat

docker run -d -ti \
  --name server_perf_tomcat \
  -v $PWD/webapps:/tomcat/default/webapps \
  -p 8080:8080 \
  -h server_perf_tomcat.dkr \
  serverperf/tomcat \
  /tomcat/default/bin/catalina.sh run

  docker ps -a

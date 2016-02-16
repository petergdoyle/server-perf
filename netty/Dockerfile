
FROM server-perf/basejdk

#COPY nettybackend/target/TestBackend-0.0.1-SNAPSHOT.jar /nettybackend/target/TestBackend-0.0.1-SNAPSHOT.jar
#COPY nettybackend/target/lib/ /nettybackend/target/lib/
#WORKDIR /nettybackend

COPY server-perf-netty-http/target/server-perf-netty-http-1.0-SNAPSHOT.jar /netty/target/server-perf-netty-http-1.0-SNAPSHOT.jar
COPY server-perf-netty-http/target/lib /netty/target/lib/

WORKDIR /netty

CMD /bin/bash

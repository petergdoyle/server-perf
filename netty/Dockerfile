
FROM server-perf/basejdk

COPY server-perf-netty-http/target/server-perf-netty-http-1.0-SNAPSHOT.jar /netty/target/server-perf-netty-http-1.0-SNAPSHOT.jar
COPY server-perf-netty-http/target/lib /netty/target/lib/

WORKDIR /netty

CMD /bin/bash


FROM server-perf/basejdk

COPY server-perf-undertow-http/target/server-perf-undertow-1.0-SNAPSHOT.jar /undertow/target/server-perf-undertow-1.0-SNAPSHOT.jar
COPY server-perf-undertow-http/target/lib /undertow/target/lib

WORKDIR /undertow

CMD /bin/bash

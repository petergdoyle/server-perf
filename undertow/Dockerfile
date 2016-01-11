
FROM server-perf/basejdk

COPY target/undertow-1.0-SNAPSHOT.jar /undertow/target/undertow-1.0-SNAPSHOT.jar
COPY target/lib /undertow/target/lib

WORKDIR /undertow

CMD /bin/bash

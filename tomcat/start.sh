

#export CATALINA_OPTS="-Dcom.sun.management.jmxremote \
#-Dcom.sun.management.jmxremote.port=3000 \
#-Djava.rmi.server.hostname=localhost \
#-Dcom.sun.management.jmxremote.authenticate=false \
#-Dcom.sun.management.jmxremote.ssl=false"

export CATALINA_OPTS="-Dcom.sun.management.jmxremote.authenticate=false \
-Dcom.sun.management.jmxremote.ssl=false \
-Djava.rmi.server.hostname=server-perf.vbx"

JAVA_OPTS="$JAVA_OPTS -Djava.rmi.server.hostname=localhost \
-Dcom.sun.management.jmxremote
-Dcom.sun.management.jmxremote.authenticate=false
-Dcom.sun.management.jmxremote.ssl=false"

/usr/tomcat/default/bin/catalina.sh run

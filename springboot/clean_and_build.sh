#!/bin/sh

rm -vfr target/
mvn -f ../java/server-perf-common/pom.xml clean install
mvn --file server-perf-springboot/springboot-undertow-pom.xml clean install
mvn --file server-perf-springboot/springboot-tomcat-pom.xml install

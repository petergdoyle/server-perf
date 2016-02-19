#!/bin/sh

rm -vfr webapps/* \
&& mvn --file ../java/server-perf-common/pom.xml clean install \
&& mvn --file ../java/server-perf-servlet/pom.xml clean install \
&& cp -v ../java/server-perf-servlet/target/servlet.war webapps/

#!/bin/sh

rm -vfr webapps/* \
&& mvn --file ../java/pom.xml clean package \
&& cp -v ../java/servlet/target/server-perf-servlet.war webapps/

#!/bin/sh

rm -vfr base/webapps/* \
&& mvn --file ../java/server-perf-common/pom.xml clean install \
&& mvn --file ../java/server-perf-servlet/pom.xml clean install \
&& cp -v ../java/servlet/target/servlet.war base/webapps/

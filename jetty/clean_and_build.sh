#!/bin/sh


if [ ! -d base/webapps/ ]; then
  mkdir -p base/webapps/
else
  rm -vfr base/webapps/*
fi

mvn --file ../java/server-perf-common/pom.xml clean install \
&& mvn --file ../java/server-perf-servlet/pom.xml clean install \
&& cp -v ../java/server-perf-servlet/target/servlet.war base/webapps/

#!/bin/sh

rm -vfr base/webapps/* \
&& mvn --file ../java/pom.xml clean install \
&& cp -v ../java/servlet/target/servlet.war base/webapps/

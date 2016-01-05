#!/bin/sh

rm -vfr base/webapps/* \
&& mvn --file ../servlet/pom.xml clean package \
&& cp -v ../servlet/target/servlet.war base/webapps/

#!/bin/sh

rm -vfr webapps/* \
&& mvn --file ../servlet/pom.xml clean package \
&& cp -v ../servlet/target/servlet.war webapps/

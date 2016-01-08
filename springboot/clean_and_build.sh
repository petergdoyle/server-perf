#!/bin/sh

rm -vfr target/
mvn --file springboot-undertow-pom.xml clean install
mvn --file springboot-tomcat-pom.xml install

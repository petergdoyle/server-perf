#!/bin/sh

rm -vfr target/
mvn --file springboot-undertow-pom.xml clean package
mvn --file springboot-tomcat-pom.xml package

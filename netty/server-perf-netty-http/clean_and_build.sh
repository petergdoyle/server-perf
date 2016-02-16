#!/bin/sh

mvn --file ../../java/server-perf-common/pom.xml clean install #to build and install that server-perf-common-1.0-SNAPSHOT dependency
mvn clean install

#!/bin/sh

mvn -f ../java/server-perf-common/pom.xml clean install
mvn -f server-perf-undertow-http/pom.xml clean install

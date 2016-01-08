#!/usr/bin/env bash

curl -O http://www.eu.apache.org/dist/jmeter/binaries/apache-jmeter-2.13.tgz
tar -xvf apache-jmeter-2.13.tgz
ln -s apache-jmeter-2.13 default
rm -f apache-jmeter-2.13.tgz

#!/bin/sh

export GOPATH=$PWD/server-perf-go
export GOBIN=$GOPATH/bin
rm -fr $GOBIN/*
cd $GOPATH/src
go install http_server.go
cd -

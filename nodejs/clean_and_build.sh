#!/bin/sh

if [ -d "node_modules" ]; then rm -vfr node_modules; fi
npm install

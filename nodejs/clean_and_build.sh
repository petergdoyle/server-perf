#!/bin/sh

if [ -d "node_modules" ]; then 
  echo "removing node_modules..."
  rm -fr node_modules
fi
npm install

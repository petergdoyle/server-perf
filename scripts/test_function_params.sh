#!/bin/sh

function1() {
  for param in "$@"
  do
      echo "$param"
  done
}

function1 hello
function1 hello world

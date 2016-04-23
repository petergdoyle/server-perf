#!/bin/sh

fx_txt='txt'
fx_gz='gz'
fx_snappy='snappy'

fldr=$1
compr_type=$2

function  gz_cmd {
  local f=$1
  local fn=$2
  local fx=$3
  echo "gzip < $f > $fldr/$fn.$fx_gz"
}
function  snappy_cmd {
  local f=$1
  local fn=$2
  local fx=$3
  #echo "python -m snappy -c $f $fldr/$fn.$fx_snappy"
  echo "cat $f |python -m snappy -c >$fldr/$fn.$fx_snappy"
}


FILES=$(find $fldr -name *$fx_txt -type f)
for f in $FILES
do
  fn=$(basename $f .$fx_txt)
  cmd=$($compr_type'_cmd' $f $fn $fx'_'$compr_type)
  eval $cmd
done

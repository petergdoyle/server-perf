#!/bin/sh

fldr=$1
compr_type=$2

fx_txt='txt'
fx_gz='gz'
fx_snappy='snappy'

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
echo ",$compr_type-real,$compr_type-user,$compr_type-sys"
FILES=$(find $fldr -name *$fx_txt -type f)
for f in $FILES
do
  fn=$(basename $f .$fx_txt)
  cmd=$($compr_type'_cmd' $f $fn $fx'_'$compr_type)
  #eval $cmd
  (time "$cmd") 2>&1 |sed '1d' | awk '{print $2}' |xargs | sed -e 's/ /,/g'|xargs -0 printf ",%s" # to print filename on each row |xargs -0 printf "$fn.gz,%s"
done

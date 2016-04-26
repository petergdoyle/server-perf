#!/bin/sh

fldr="estreaming-data"
fx_txt='txt'
fx_gz='gz'
fx_snappy='snappy'


FILES=$(find $fldr -name *$fx_txt -type f)
printf "%s,%s,%s,%s,%s,%s\n" "filename" "gz size" "snappy size" "original size" "gz compression pct" "snappy compression pct"
for f in $FILES
do
  fn=$(basename $f .$fx_txt)
  #get the file sizes for all three in the set {gz,snappy,txt}
  fnset=$(find $fldr -name $fn.* -type f -exec ls -al {} \;| awk '{ print $5 }')
  fn_anon=$(echo $fn | sed 's/Input-//g') #to cut the identifier off the front of the record
  #put the filename into a formatted line with the 3 file sizes
  prelim=$(printf "%s,%d,%d,%d\n" $fn_anon $fnset)
  printf "%s,%.0f%%,%.0f%%\n" "$prelim" $(echo $prelim| awk -F',' '{ print 100-($2/$4*100) }') $(echo $prelim| awk -F',' '{ print 100-($3/$4*100) }')
done

#!/bin/sh
while true; do
  read -e -p "Enter folder with files to compress: " -i "$PWD/estreaming-data" fldr
  if [ ! -d $fldr ]; then
    echo "invalid location"
  else
    break
  fi
done

while true; do
echo -e "*** select the compression type *** \n\
1) zlib \n\
2) snappy \
"
read opt
case $opt in
    1)
    compr_type='gz'
    break
    ;;
    2)
    compr_type='snappy'
    break
    ;;
    *)
    echo "invalid option"
    ;;
esac
done

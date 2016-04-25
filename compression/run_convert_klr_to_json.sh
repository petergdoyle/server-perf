#!/bin/sh

fin=$1

if [[ "$2" == "y" || "$2" == "Y" ]]; then
  pretty_print="y"
else
  pretty_print="n"
fi
change_file_ext() {
  fnfx=$1
  ext=$2
  fn=$(echo $1 | cut -f 1 -d '.')
  echo "$fn$ext"
}
fout=$(change_file_ext $fin '.json')
sed_remove_tabs='s/^[ \t]*//'
sed_remove_newlines=':a;N;$!ba;s/\n//g'
#echo $sed_remove_tabs
#echo $sed_remove_newlines
if [ "$pretty_print" == "y" ]; then
  ./convert_klr_to_json.sh $fin > $fout
else
  ./convert_klr_to_json.sh $fin |sed 's/^[ \t]*//' |sed ':a;N;$!ba;s/\n//g' > $fout
fi

#!/bin/sh

fin=$1 #"$PWD/estreaming-data-json/Input-1V_J0B_ATLPAR-3412-0008-0924-172400-266.txt"
if [[ ! -f "$fin" ]]; then
  echo "file does not exist. cannot continue"
  exit 1
fi
fn=$(basename "$fin" | cut -d. -f1| sed 's/Input-//g')

regex='\([[:digit:]]\{4\}[[:alpha:]]\{4\}[[:digit:]]\{3\}[[:upper:]][[:digit:]]\{4\}\)'
replacement='"\n\t\t},\n\t\t{\n\t\t"header":"\1",\n\t\t"body":"'
echo -e "{\n\"airshop-solution\":["
echo -e "\t{\"id\":\"$fn\"},"
echo -e "\t{\"klrs\": ["
sed 's/'$regex'/'$replacement'/g' $fin |sed '1,2d'
echo -e "\"\n}]\n}]\n}"

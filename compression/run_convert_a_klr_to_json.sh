#!/bin/sh

./convert_klr_to_json.sh estreaming-data-json/Input-1V_J0B_ATLPAR-3412-0008-0924-172400-266.txt |sed '2d' |less

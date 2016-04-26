#!/bin/sh

find estreaming-data/ -name '*.txt' -exec ./run_convert_klr_to_json.sh {} \;

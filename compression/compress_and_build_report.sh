#!/bin/sh


./compress_files.sh estreaming-data/ snappy > compress-snappy.csv
./compress_files.sh estreaming-data/ gz > compress-gz.csv
paste compare_file_compression.csv compress-gz.csv compress-snappy.csv > individual_file_compression.csv

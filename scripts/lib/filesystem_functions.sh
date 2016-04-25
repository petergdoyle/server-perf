#!/bin/sh

#
# usage fn=$(strip_file_ext "/some/file.out")
# echo $fn
#file
strip_file_ext() {
  fnfx=$1
  fn=$(basename "$fnfx" | cut -d. -f1)
  echo $fn
}

change_file_ext() {
  fnfx=$1
  ext=$2
  fn=$(echo $1 | cut -f 1 -d '.')
  echo "$fn$ext"
}
count_files_and_calculate_avg_file_size_dir() {
  dir=$1
  find $dir -type f -printf '%s\n' | awk '{s+=$0} END {printf "Count: %u\nAverage size: %.2fkb\n", NR, s/NR/1000}'
}

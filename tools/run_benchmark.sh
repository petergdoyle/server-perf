#!/bin/sh
. ../scripts/lib/color_and_format_functions.sh

check_install_perf_pack() {
  read -e -p "Install perf-pack? (y/n): " -i "y" install_perf_pack
  if [ "$install_perf_pack" == "y" ]; then
    cd /tmp
    curl -s https://raw.githubusercontent.com/petergdoyle/devops-scripts/master/bash/centos/vagrant/perf-pack/os_perf_utils.sh |sudo bash -s
    cd -
  fi
}

while true; do
echo -e "*** select a benchmark tool *** \n\
1) apache bench (ab) \n\
2) siege \n\
3) httpress \n\
4) httperf \n\
5) autobench (stepped load using httperf with aggregated results) \n\
6) weighttp \n\
7) wrk \
"
read opt

case $opt in
    1)
    eval $'ab' > /dev/null 2>&1
    if [ $? -eq 127 ]; then
      display_error "ab is not installed"
      check_install_perf_pack
    else
      benchmark_tool='ab'
      break
    fi
    ;;
    2)
    eval $'siege' > /dev/null 2>&1
    if [ $? -eq 127 ]; then
      display_error "siege is not installed"
      check_install_perf_pack
    else
      benchmark_tool='siege'
      break
    fi
    ;;
    3)
    eval $'httpress' > /dev/null 2>&1
    if [ $? -eq 127 ]; then
      display_error "httpress is not installed"
      check_install_perf_pack
    else
      benchmark_tool='httpress'
      break
    fi
    ;;
    4)
    eval $'httperf' > /dev/null 2>&1
    if [ $? -eq 127 ]; then
      display_error "httperf is not installed"
      check_install_perf_pack
    else
      benchmark_tool='httperf'
      break
    fi
    ;;
    5)
    eval $'autobench' > /dev/null 2>&1
    if [ $? -eq 127 ]; then
      display_error "autobench is not installed"
      check_install_perf_pack
    else
      benchmark_tool='autobench'
      break
    fi
    ;;
    6)
    eval $'weighttp' > /dev/null 2>&1
    if [ $? -eq 127 ]; then
      display_error "weighttp is not installed"
      check_install_perf_pack
    else
      benchmark_tool='weighttp'
      break
    fi
    ;;
    7)
    eval $'wrk' > /dev/null 2>&1
    if [ $? -eq 127 ]; then
      display_error "wrk is not installed"
      check_install_perf_pack
    else
      benchmark_tool='wrk'
      break
    fi
    ;;
    *)
    echo "invalid option"
    ;;
esac
done

_script_name='./run_'$benchmark_tool'_benchmark.sh'

eval $_script_name $benchmark_tool

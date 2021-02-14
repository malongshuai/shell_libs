#!/usr/bin/env bash

########  function `get_script_dir`: get the scirpt dirname ########

#### function get_script_dir start ####
# Desc: display the directory of current script
# Usage: 
#  1. if this function used in sourcing script, 
#       get_script_dir -s
#  2. if this function used in binary shell script,
#       get_script_dir
get_script_dir(){
  # for i in "${BASH_SOURCE[@]}";do echo $i; done
  local sourced__=0
  [ "x$1" = "x-s" ] && sourced__=1
  if [ $sourced__ -eq 1 ];then
    dirname "$(realpath "${BASH_SOURCE[1]}")"
  else
    dirname "$(realpath "${BASH_SOURCE[-1]}")"
  fi
}

export -f get_script_dir
#### function get_script_dir end ####

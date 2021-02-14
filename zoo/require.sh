#!/usr/bin/env bash

######## function `require`: require shell libs #########

#### function require start ####
# Usage: require 'PATH_TO_SHELL_LIB'
require(){
  local path__="$1"
  local real_path__="$(realpath "$path__")"
  # require a shell lib only one time
  # all required lib will record to array `required_path_arr__`
  declare -p required_path_arr__ &>/dev/null || declare -gA required_path_arr__
  if [ -x "$path__" -a $((required_path_arr__["${real_path__}"])) -eq 0 ];then
    source "$path__" && required_path_arr__["${real_path__}"]=1
    echo "已加载库: $real_path__"
  fi
}
export -f require
#### function require end ####

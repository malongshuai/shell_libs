#!/usr/bin/env bash

########  function `repeat_str`: repeat str some times ########

#### function repeat_str start ####
# Usage: repeat_str [-v VAR] Str N
#   N: must be integer, and great than 0
#  -v: assign repeated str to shell variable VAR,
#      rather than output it
repeat_str(){
  [ $# -lt 2 ] && {
    echo "function \`${FUNCNAME[0]}' arguments wrong"
    return 1
  }

  local var_flag__=0
  [ "x$1" == "x-v" ] && {
    var_flag__=1
    local var_name__=$2
    shift 2
  }
  local str__=$1

  # cnt__ must be integer and great than 0
  local cnt__
  declare -i cnt__
  cnt__=$2
  [ ${cnt__} -le 0 ] && return

  if [ ${var_flag__} -eq 1 ];then
    eval printf -v ${var_name__} -- "${str__}%.0s" {1..${cnt__}}
  else
    eval printf -- "${str__}%.0s" {1..${cnt__}}
  fi
}

#### test
repeat_str_test()(
  cd "$(dirname "$(realpath "${BASH_SOURCE[0]}")")"
  [ -x "./../zoo/assert.sh" ] && source "./../zoo/assert.sh"
  assert_eq "$(repeat_str - 5)" "-----" "repeat_str1"
  assert_eq "$(repeat_str ab 3)" "ababab" "repeat_str2"
)
[ "x$1" == "xtest" ] && repeat_str_test

export -f repeat_str
#### function repeat_str end ####

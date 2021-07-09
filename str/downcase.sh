#!/usr/bin/env bash

######## function `downcase`: downcase string ########

#### function downcase start ####
# Usage: downcase [-v VAR] Str
#  -v: assign downcased str to shell variable VAR,
#      rather than output it

downcase(){
  local var_flag__=0
  [ "x$1" == "x-v" ] && {
    var_flag__=1
    local var_name__=$2
    shift 2
  }

  [ $# -ne 1 ] && {
    echo "function \`${FUNCNAME[0]}' arguments wrong"
    return 1
  }

  local tmp_str__=$1

  if [ $var_flag__ -eq 1 ];then
    printf -v "$var_name__" "%s" "${tmp_str__,,}"
  else
    printf "%s" "${tmp_str__,,}"
  fi
}

### test func
downcase_test()(
  cd "$(dirname "$(realpath "${BASH_SOURCE[0]}")")" || return
  [ -x "./../zoo/assert.sh" ] && source "./../zoo/assert.sh"
  assert_eq "$(downcase 'HELLO WORLD')" "hello world" "downcase 1"
  local s__
  downcase -v s__ "Hello World"
  assert_eq "$s__" "hello world" "downcase 2"
)
[ "x$1" = "xtest" ] && downcase_test; unset downcase_test

export -f downcase
#### function downcase end #####

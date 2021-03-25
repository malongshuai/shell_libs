#!/usr/bin/env bash

######## function `upcase`: upcase string ########

#### function upcase start ####
# Usage: upcase [-v VAR] Str
#  -v: assign upcased str to shell variable VAR,
#      rather than output it

upcase(){
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
    printf -v $var_name__ "%s" "${tmp_str__^^}"
  else
    printf "%s" "${tmp_str__^^}"
  fi
}

### test func
upcase_test()(
  cd "$(dirname "$(realpath "${BASH_SOURCE[0]}")")" || return
  [ -x "./../zoo/assert.sh" ] && source "./../zoo/assert.sh"
  assert_eq "$(upcase 'hello world')" "HELLO WORLD" "upcase 1"
  local s__
  upcase -v s__ "Hello World"
  assert_eq "$s__" "HELLO WORLD" "upcase 2"
)
[ "x$1" = "xtest" ] && upcase_test

export -f upcase
#### function upcase end #####

#!/usr/bin/env bash

######## function `chars`: get the array of characters in string ########

#### function chars start #####
# ! Desc: get the array of characters in string
# ! Usage: chars [-v ARRAY] Str
# !   chars 'abcd'  # (a b c d)
# !   chars -v arr 'abcd'  # arr=(a b c d)
chars(){
  [ $# -lt 1 ] && {
    echo "function \`${FUNCNAME[0]}' arguments wrong"
    return 1
  }

  local arr_name__

  local var_flag__=0
  [ "x$1" == "x-v" ] && {
    var_flag__=1
    declare -n arr_name__=$2
    shift 2
  }

  local str__="$1"

  local i__=0
  for((;i__ < ${#str__};i__++)){
    arr_name__[${i__}]="${str__:${i__}:1}"
  }

  if [ ${var_flag__} -eq 0 ];then
    echo "${arr_name__[@]}"
  fi
}

### test func
chars_test()(
  cd "$(dirname "$(realpath "${BASH_SOURCE[0]}")")"
  [ -x "./../zoo/assert.sh" ] && source "./../zoo/assert.sh"
  assert_eq "$(chars 'a你 b d')" "a 你   b   d" "chars1"

  chars -v arr 'a你 b d'
  assert_arr_eq arr '(a 你 " " b " " d)' "chars2"
)
[ "x$1" = "xtest" ] && chars_test

export -f chars
#### function chars end #####







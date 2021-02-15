#!/usr/bin/env bash

if [[ -t 1 ]];then # is terminal?
  RED__="\e[0;31m";    RED_BOLD__="\e[1;31m";
  GREEN__="\e[0;32m";  GREEN_BOLD__="\e[1;32m";
  BLUE__="\e[0;34m";   BLUE_BOLD__="\e[1;34m";
  RESET__="\e[0m";
fi
___msg()    { echo -e "${BLUE__}  ${@}${RESET__}"; }
___ok()     { echo -e "${GREEN__}${@}...........ok${RESET__}"; }
___not_ok() { echo -e "${RED_BOLD__}${RED__}$@...........not ok${RESET__}"; }
___error()  { echo -e "${RED_BOLD__}  Error: ${RED__}$@${RESET__}\n";return 1; }

########  function `assert_eq`: test two string ########

#### function assert_eq start ####
## Usage:
##   assert_eq str1 expect_str
##   assert_eq str1 expect_str error_message
assert_eq(){
  [ $# -lt 2 ] && {
    ___error "\`${FUNCNAME[0]}' argument wrong"
    return 1
  }

  local given__="$1"
  local expect__="$2"
  local message__="$3"
  if [ "x$given__" == "x${expect__}" ];then
    return 0
  else
    [ "$message__" ] && ___not_ok "$message__"
    echo "Left Value: \`$given__'"
    echo "Right Value: \`$expect__'"
    return 1
  fi
}

# function assert_eq(){
#   [ $# -lt 2 ] && {
#     ___error "\`${FUNCNAME[0]}' argument wrong"
#     return 1
#   }

#   local cmd="$1"
#   local cmd_name=${cmd%% *}
#   local val="$2"
#   local message="$3"
#   local cmd_res="$(set -- $cmd;cmd=$1;shift;eval set -- "$@";$cmd "$@")"
#   if [ "x$cmd_res" == "x${val}" ];then
#     ___ok "${cmd_name}..............ok"
#     return 0
#   else
#     ___not_ok "${cmd_name}..............not ok"
#     echo "Exec Res: $cmd_res"
#     echo "Expect Res: $val"
#     [ "$message" ] && ___msg "$message"
#     return 1
#   fi
# }


#### test myself
assert_eq_test()(
  assert_eq "hello world" "hello world" "msg"
  assert_eq "hello world" "hello worl"
  assert_eq "hello world" "hello worl"  "msg"
)
[ "x$1" == "xtest" ] && assert_eq_test


export -f assert_eq
#### function assert_eq end ####



########  function `assert_arr_eq`: test array ########

#### function assert_arr_eq start ####
# Usage: assert_arr_eq arr_name "(elem1 elem2 elem3 ...)" [Message]
assert_arr_eq(){
  [ $# -lt 2 ] && {
    ___error "\`${FUNCNAME[0]}' argument wrong"
    return 1
  }

  local -n arr_name__=$1
  local expect_arr__
  eval expect_arr__="$2"

  local message__=$3

  # check length
  [ ${#arr_name__[@]} -ne ${#expect_arr__[@]} ] && {
    [ "$message__" ] && ___not_ok "$message__"
    echo "Given Arr: \`(${arr_name__[@]})'"
    echo "Expect Arr: \`(${expect_arr__[@]})'"
    return 1
  }

  for((i=0;i<${#arr_name__[@]};i++));do
    # echo "arr_name: ${arr_name[$i]}"
    # echo "expect_name: ${expect_arr[$i]}"
    [ "${arr_name__[$i]}" != "${expect_arr__[$i]}" ] && {
      [ "$message__" ] && ___not_ok "$message__"
      echo "Given Arr: \`(${arr_name__[@]})'"
      echo "Expect Arr: \`(${expect_arr__[@]})'"
      return 1
    }
  done
  return 0
}

#### test myself
assert_arr_eq_test()(
  local arr1
  declare -a arr1
  arr1=(a b c "d e" f)
  assert_arr_eq arr1 '(a b c "d e" f)' "arr1"
)
[ "x$1" == "xtest" ] && assert_arr_eq_test

export -f assert_arr_eq
#### function assert_arr_eq end ####


#!/usr/bin/env bash

######## function `is_int`: test integer ########

#### function is_int start #####
# ! Desc: is_int test whether the given value is an integer
# ! Usage: is_int N
# !   If N is an integer, return code 0, otherwise 1.
is_int(){
  (( $1 + 0 )) &>/dev/null && return 0
  return 1
}

# test func
is_int_test()(
  cd "$(dirname "$(realpath "${BASH_SOURCE[0]}")")"
  [ -x "./../zoo/assert.sh" ] && source "./../zoo/assert.sh"

  is_int 3
  assert_eq "$?" 0 "is_int1"
  is_int 033
  assert_eq "$?" 0 "is_int2"
  is_int 0x33
  assert_eq "$?" 0 "is_int3"
  is_int 0b1001
  assert_eq "$?" 0 "is_int4"
  is_int 0a33
  assert_eq "$?" 1 "is_int5"
  is_int
  assert_eq "$?" 1 "is_int6"
)
[ "x$1" = "xtest" ] && is_int_test

export -f is_int
#### function is_int end #####

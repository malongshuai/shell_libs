#!/usr/bin/env bash

########  function `split`: split str to array ########

#### function split start #####
# ! Desc: split str to array
# ! Usage: split -v ARRAY [SEP] STRING
# ! Default: trim leading and trailing seperator
# !          chars first, then split to array.
# !          Default seperator is space.
# !          Sequence sep will squash to single
# !          seperator before spliting.
# ! e.g.
# !     split -v arr 'x' 'xxabcxdefxghixjklxx'
# !     #=> arr=(abc def ghi jkl)
# !     split -v arr1 ' abc  def  ghi  jkl  '
# !     #=> arr1=(abc def ghi jkl)
split(){
  if [ $# -lt 3 ] || [ "x$1" != "x-v" ];then
    echo "function \`${FUNCNAME[0]}' arguments wrong"
    return 1
  fi

  local arr_name__
  declare -n arr_name__=$2
  shift 2

  local sep__=" "
  [ $# -eq 2 ] && {
    sep__="$1"
    shift
  }

  local str__="$1"

  [ $# -gt 1 ] && {
    echo "function \`${FUNCNAME[0]}' arguments wrong"
    return 1
  }

  shopt -s extglob
  # trim leading and trailing seperator chars first
  str__="${str__%%+("${sep__}")}"
  str__="${str__##+("${sep__}")}"

  arr_name__=(${str__//+("${sep__}")/ })
  shopt -u extglob
}

# test func
split_test()(
  cd "$(dirname "$(realpath "${BASH_SOURCE[0]}")")"
  [ -x "./../zoo/assert.sh" ] && source ./../zoo/assert.sh
  local arr
  split -v arr 'x' 'xxabcxdefxghixjklxx'
  assert_arr_eq arr '(abc def ghi jkl)' 'split 1'

  local arr1
  split -v arr1 ' abc  def  ghi  jkl  '
  assert_arr_eq arr1 '(abc def ghi jkl)' 'split 2'
)
[ "x$1" = "xtest" ] && split_test

export -f split
#### function split end #####
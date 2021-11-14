#!/usr/bin/env bash

########  function `trim`: trim leading and trailing whitespaces ########


#### function trim start #####
# ! Desc: trim leading and trailing whitespaces
# ! Usage: trim [-l] [-r] [-v VAR] [Target] STRING
# !     Default: trim leading and trailing whitespaces
# !     Target: trim specify char(s). If omit,
# !             default to trim whitespaces
# !    -l: only trim leading chars
# !    -r: only trim trailing chars
# !    -v VAR: assign result to shell variable VAR,
# !            rather than output it
# ! e.g.
# !   trim '  ab  '         # ab
# !   trim -l '  ab  '      # "ab  "
# !   trim -l -r '  ab  '   # "ab"
# !   trim -l xy 'xyxyab'   # "ab"
# !   trim -v var 'xy' 'xyxyab'   # var="ab"
trim(){
  local ltrim__=0
  local rtrim__=0
  local target__="[:space:]"
  local var_flag__=0

  while [ $# -gt 1 ];do
    case "$1" in 
      -l)   ltrim__=1; shift;;
      -r)   rtrim__=1; shift;;
      -v)
        var_flag__=1;
        local var_name__=$2;
        shift 2;;
      *)
        target__="$1"
        shift
        [ $# -gt 1 ] && {
          echo "\`${FUNCNAME[0]}' argument wrong"
          return 1
        }
    esac
  done

  # default: left trim and right trim
  if ((ltrim__ == 0)) && ((rtrim__ == 0));then
    ltrim__=1
    rtrim__=1
  fi

  local str__="$1"

  # default: trim whitespace
  if [ "x${target__}" = "x[:space:]" ];then
    (( ltrim__ == 1 )) && str__="${str__#"${str__%%[^[:space:]]*}"}"
    (( rtrim__ == 1 )) && str__="${str__%"${str__##*[^[:space:]]}"}"
  else
    shopt -s extglob
    (( rtrim__ == 1 )) && str__="${str__%%+("${target__}")}"
    (( ltrim__ == 1 )) && str__="${str__##+("${target__}")}"
    shopt -u extglob
  fi

  if [ $var_flag__ -eq 1 ];then
    printf -v $var_name__ "%s" "${str__}"
  else
    printf "%s" "${str__}"
  fi
}

# test func
trim_test()(
  cd "$(dirname "$(realpath "${BASH_SOURCE[0]}")")"
  [ -x "./../zoo/assert.sh" ] && source ./../zoo/assert.sh
  assert_eq "$(trim '  a b  ')"       "a b"   "trim whitespace1"
  assert_eq "$(trim -l '  a b  ')"    "a b  " "trim whitespace2"
  assert_eq "$(trim -r '  a b  ')"    "  a b" "trim whitespace3"
  assert_eq "$(trim -r -l '  a b  ')" "a b"   "trim whitespace4"

  assert_eq "$(trim 'x' 'xa bx')" "a b"   "trim single char 1"
  assert_eq "$(trim 'x' 'xxa bxx')" "a b"   "trim single char 2"
  assert_eq "$(trim -l 'x' 'xxa bxx')" "a bxx"   "trim single char 3"
  assert_eq "$(trim -r 'x' 'xxa bxx')" "xxa b"   "trim single char 4"
  assert_eq "$(trim -r -l 'x' 'xxa bxx')" "a b"   "trim single char 5"

  assert_eq "$(trim -l 'xy' 'xyxya bxyxy')" "a bxyxy"   "trim chars 1"
  assert_eq "$(trim -r 'xy' 'xyxya bxyxy')" "xyxya b"   "trim chars 2"
  assert_eq "$(trim 'xy' 'xyxya bxyxy')" "a b"   "trim chars 3"
  assert_eq "$(trim 'xy' 'a b')" "a b"   "trim chars 4"
)
[ "x$1" = "xtest" ] && trim_test; unset trim_test

export -f trim
#### function trim end #####

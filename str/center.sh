#!/usr/bin/env bash

######## function `center`: center a str with whitespace or given string ########

#### function center start ####
# ! Usage: center [-v VAR] [-l Len] [-p Padding_str] Str
# !   -v: assign justified str to shell variable VAR,
# !       rather than output it
# !   -l Len: the length of padded string, default len: 80
# !   -p Padding_str: used for padding, default pad with whitespace
# ! e.g.
# !   center -l 10 "hell"   # '   hell   '
# !   center -l 10 "hello"  # '   hello  '
center(){
  local var_flag__=0
  [ "x$1" == "x-v" ] && {
    var_flag__=1
    local var_name__=$2
    shift 2
  }

  # default len: 80
  # default padding str: whitespace
  local len__=80
  local padding__=" "

  while [ $# -gt 1 ];do
    case "$1" in
      -l)
        len__=$2;
        shift 2;
        (( len__ + 0 )) &>/dev/null || {
          echo "\`Len' should be a num"
          return 1
        }
        ;;
      -p) padding__="$2"; shift 2;;
      *)
        echo "\`${FUNCNAME[0]}' arguments wrong"
        return 1
    esac
  done

  local tmp_str__="$1"

  local tmp_str_len__=${#tmp_str__}
  local left_cnt__=$(( (len__ - tmp_str_len__) / 2 ))
  local right_cnt__=${left_cnt__}
  if [ $(( (len__ - tmp_str_len__) % 2)) -eq 1 ];then
    ((left_cnt__++))
  fi

  local left_str__
  local right_str__
  eval printf -v left_str__ \""${padding__}"%.0s\" "{1..$((left_cnt__/${#padding__}+1))}"
  left_str__="${left_str__:0:${left_cnt__}}"
  right_str__="${left_str__:0:${right_cnt__}}"

  if [ ${var_flag__} -eq 1 ];then
    printf -v "$var_name__" "%s" "${left_str__}" "${tmp_str__}" "${right_str__}"
  else
    printf "%s" "${left_str__}" "${tmp_str__}" "${right_str__}"
  fi
}

### test func
center_test()(
  cd "$(dirname "$(realpath "${BASH_SOURCE[0]}")")" || return
  [ -x "./../zoo/assert.sh" ] && source "./../zoo/assert.sh"

  assert_eq "$(center -l 15 "hell")" "      hell     " "center1"
  assert_eq "$(center -l 15 -p abc " hell ")" "abcab hell abca" "center2"
  assert_eq "$(center -l 15 -p abc " hihello ")" "abc hihello abc" "center3"

  local s__
  center -v s__ -l 15 "hell"
  assert_eq "${s__}" "      hell     " "center4"
)
[ "x$1" = "xtest" ] && center_test

export -f center
#### function center end #####

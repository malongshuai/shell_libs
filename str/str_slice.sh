#!/usr/bin/env bash

######## function `str_slice`: get the slice of string ########

#### function str_slice start ####
# ! Usage: (1) str_slice [-v Var] Str
# !        (2) str_slice [-v VAR] M..N Str
# !        (3) str_slice [-v VAR] N [Len] Str
# !   -v Var: assign substr to shell variable VAR,
# !       rather than output it
# !   syntax (1):
# !     get the copy of Str
# !   syntax (2):
# !     M..N: index range, get chars from M to N, support
# !           range formats: `M..N, ..N, M..`. M and N can
# !           be negative, it means index evaluates from
# !           the end of Str.
# !     Note: position M should in the left of position N
# !   syntax (3):
# !     N [Len]: get Len chars from N. N can be negative,
# !              it means N evaluates from the end of Str.
# !              If omit Len, get chars from N to end. If
# !              Len is negative, it means get chars from
# !              index N to Len(from the end of Str).
# ! e.g.
# !   test_str__="01234567890abcdefgh"
# !   str_slice "${test_str}"       # "01234567890abcdefgh"
# !
# !   str_slice 1..3 "${test_str}"  # "123"
# !   str_slice 7.. "${test_str}"   # "7890abcdefgh"
# !   str_slice ..7 "${test_str}"   # "01234567"
# !   str_slice 1..-7 "${test_str}" # "1234567890ab"
# !   str_slice -7.. "${test_str}"  # "bcdefgh"
# !   str_slice ..-7 "${test_str}"  # "01234567890ab"
# !   str_slice -10..-7 "${test_str}"  # "90ab"
# !
# !   str_slice 7 "${test_str}"     # "7890abcdefgh"
# !   str_slice 7 0 "${test_str}"   # ""
# !   str_slice 7 2 "${test_str}"   # "78"
# !   str_slice 7 -2 "${test_str}"  # "7890abcdef"
# !   str_slice -7 "${test_str}"    # "bcdefgh"
# !   str_slice -7 2 "${test_str}"  # "bc"
# !   str_slice -7 -2 "${test_str}" # "bcdef"
str_slice(){
  local var_flag__=0
  [ "x$1" == "x-v" ] && {
    var_flag__=1
    local var_name__=$2
    shift 2
  }

  [[ $# -lt 1 || $# -gt 3 ]] && {
    echo "function \`${FUNCNAME[0]}' arguments wrong"
    return 1
  }

  local min_idx__
  local max_idx__
  local tmp_str__
  local substr_len__

  # calling: ${FUNCNAME[0]} [-v VAR] Str
  if [ $# -eq 1 ];then
    tmp_str__="$1"
    min_idx__=0
    max_idx__=$(( ${#tmp_str__} - 1 ))
  fi

  if [ $# -eq 2 ];then
    tmp_str__="$2"
    local tmp_idx__=$1
    shopt -s extglob

    # calling: ${FUNCNAME[0]} [-v VAR] Start Str
    if [ "x${tmp_idx__//?(-)+([0-9])/}" == "x"  ]; then
      min_idx__=${tmp_idx__}
      max_idx__=$(( ${#tmp_str__} - 1 ))
    # calling: ${FUNCNAME[0]} [-v VAR] Start..End Str
    elif [ "x${tmp_idx__//?(-)+([0-9])..?(-)+([0-9])/}" == "x" ];then
      min_idx__=${tmp_idx__//..*/}
      max_idx__=${tmp_idx__//*../}
    # calling: ${FUNCNAME[0]} [-v VAR] Start.. Str
    elif [ "x${tmp_idx__//?(-)+([0-9])../}" == "x" ]; then
      min_idx__=${tmp_idx__//..*/}
      max_idx__=$(( ${#tmp_str__} - 1 ))
    # calling: ${FUNCNAME[0]} [-v VAR] ..End Str
    elif [ "x${tmp_idx__//..?(-)+([0-9])/}" == "x" ]; then
      min_idx__=0
      max_idx__=${tmp_idx__//*../}
    else
      echo "range formats: 'M..N' or 'M..' or '..N'"
      return 1
    fi

    shopt -u extglob
  fi

  # calling: ${FUNCNAME[0]} [-v VAR] Start Len Str
  if [ $# -eq 3 ];then
    tmp_str__=$3
    min_idx__=$1

    if [ $(($2+0)) -ge 0 ];then
      max_idx__=$(( min_idx__ + $2 - 1 ))
    elif [ $(($2+0)) -lt 0 ];then
      max_idx__=$(( ${#tmp_str__} + $2 - 1 ))
    fi
  fi

  if [ $(( min_idx__ + 0)) -lt 0 ];then
    min_idx__=$(( ${#tmp_str__} + min_idx__ ))
  fi

  if [ $(( max_idx__ + 0)) -lt 0 ];then
    max_idx__=$(( ${#tmp_str__} + max_idx__ ))
  fi

  substr_len__=$((max_idx__ - min_idx__ + 1))
  [ $((substr_len__+0)) -lt 0 ] && {
    echo "range error"
    return 1
  }

  if [ ${var_flag__} -eq 1 ];then
    printf -v "${var_name__}" "%s" "${tmp_str__: ${min_idx__}:${substr_len__}}"
  else
    printf "%s" "${tmp_str__: ${min_idx__}:${substr_len__}}"
  fi
}

### test func
str_slice_test()(
  cd "$(dirname "$(realpath "${BASH_SOURCE[0]}")")" || return
  [ -x "./../zoo/assert.sh" ] && source "./../zoo/assert.sh"

  local test_str__="01234567890abcdefgh"

  assert_eq "$(str_slice 7 "${test_str__}")" "7890abcdefgh" "str_slice 1"
  assert_eq "$(str_slice 7 0 "${test_str__}")" "" "str_slice 2"
  assert_eq "$(str_slice 7 2 "${test_str__}")" "78" "str_slice 3"
  assert_eq "$(str_slice 7 -2 "${test_str__}")" "7890abcdef" "str_slice 4"
  assert_eq "$(str_slice -7 "${test_str__}")" "bcdefgh" "str_slice 5"
  assert_eq "$(str_slice -7 2 "${test_str__}")" "bc" "str_slice 6"
  assert_eq "$(str_slice -7 -2 "${test_str__}")" "bcdef" "str_slice 7"
  assert_eq "$(str_slice "${test_str__}")" "01234567890abcdefgh" "str_slice 8"
  assert_eq "$(str_slice 1..3 "${test_str__}")" "123" "str_slice 9"
  assert_eq "$(str_slice 7.. "${test_str__}")" "7890abcdefgh" "str_slice 10"
  assert_eq "$(str_slice ..7 "${test_str__}")" "01234567" "str_slice 11"
  assert_eq "$(str_slice 1..-7 "${test_str__}")" "1234567890ab" "str_slice 12"
  assert_eq "$(str_slice -7.. "${test_str__}")" "bcdefgh" "str_slice 13"
  assert_eq "$(str_slice ..-7 "${test_str__}")" "01234567890ab" "str_slice 14"
  assert_eq "$(str_slice -10..-7 "${test_str__}")" "90ab" "str_slice 15"

  local s__
  str_slice -v s__ -7 -2 "${test_str__}"
  assert_eq "${s__}" "bcdef" "str_slice 15"
)
[ "x$1" = "xtest" ] && str_slice_test

export -f str_slice
#### function str_slice end #####

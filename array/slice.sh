#!/usr/bin/env bash

######## function `slice`: get the slice of Array ########

#### function slice start ####
# ! Usage: (1) slice -v Arr_Var Arr
# !        (2) slice -v Arr_Var M..N Arr
# !        (3) slice -v Arr_Var N [Len] Arr
# !   -v Arr_Var: assign slice to shell Array Arr_Var
# !   syntax (1):
# !     get the copy of Arr
# !   syntax (2):
# !     M..N: index range, get elements from M to N, support
# !           range formats: `M..N, ..N, M..`. M and N can
# !           be negative, it means index evaluates from
# !           the end of Array.
# !     Note: position M should in the left of position N
# !   syntax (3):
# !     N [Len]: get Len elements from N. N can be negative,
# !              it means N evaluates from the end of Array.
# !              If omit Len, get elements from N to end. If
# !              Len is negative, it means get elements from
# !              index N to Len(from the end of Array).
# ! e.g.
# ! local test_arr=(0 1 2 3 4 5 6 7 8 9 0 a b c d e f g h)
# ! local res_arr
# ! slice -v res_arr 7 test_arr       # "(7 8 9 0 a b c d e f g h)"
# ! slice -v res_arr 7 0 test_arr     # "()"
# ! slice -v res_arr 7 2 test_arr     # "(7 8)"
# ! slice -v res_arr 7 -2 test_arr    # "(7 8 9 0 a b c d e f)"
# ! slice -v res_arr -7 test_arr      # "(b c d e f g h)"
# ! slice -v res_arr -7 2 test_arr    # "(b c)"
# ! slice -v res_arr -7 -2 test_arr   # "(b c d e f)"
# ! slice -v res_arr test_arr         # "(0 1 2 3 4 5 6 7 8 9 0 a b c d e f g h)"
# ! slice -v res_arr 1..3 test_arr    # "(1 2 3)"
# ! slice -v res_arr 7.. test_arr     # "(7 8 9 0 a b c d e f g h)"
# ! slice -v res_arr ..7 test_arr     # "(0 1 2 3 4 5 6 7)"
# ! slice -v res_arr 1..-7 test_arr   # "(1 2 3 4 5 6 7 8 9 0 a b)"
# ! slice -v res_arr -7.. test_arr    # "(b c d e f g h)"
# ! slice -v res_arr ..-7 test_arr    # "(0 1 2 3 4 5 6 7 8 9 0 a b)"
# ! slice -v res_arr -10..-7 test_arr # "(9 0 a b)"
slice(){
  [ "x$1" != "x-v" ] && {
    echo "function \`${FUNCNAME[0]}' arguments wrong: -v must be first argument"
    return 1
  }

  declare -n arr_name__=$2
  shift 2

  [[ $# -lt 1 || $# -gt 3 ]] && {
    echo "function \`${FUNCNAME[0]}' arguments wrong"
    return 1
  }

  local min_idx__
  local max_idx__
  local tmp_arr__
  local subarr_len__

  # calling: ${FUNCNAME[0]} [-v Arr_VAR] Arr
  if [ $# -eq 1 ];then
    declare -n tmp_arr__="$1"
    min_idx__=0
    max_idx__=$(( ${#tmp_arr__[@]} - 1 ))
  fi

  if [ $# -eq 2 ];then
    declare -n tmp_arr__="$2"
    local tmp_idx__=$1
    shopt -s extglob

    # calling: ${FUNCNAME[0]} [-v VAR] Start Str
    if [ "x${tmp_idx__//?(-)+([0-9])/}" == "x" ]; then
      min_idx__=${tmp_idx__}
      max_idx__=$(( ${#tmp_arr__[@]} - 1 ))
    # calling: ${FUNCNAME[0]} [-v VAR] Start..End Str
    elif [ "x${tmp_idx__//?(-)+([0-9])..?(-)+([0-9])/}" == "x" ];then
      min_idx__=${tmp_idx__//..*/}
      max_idx__=${tmp_idx__//*../}
    # calling: ${FUNCNAME[0]} [-v VAR] Start.. Str
    elif [ "x${tmp_idx__//?(-)+([0-9])../}" == "x" ]; then
      min_idx__=${tmp_idx__//..*/}
      max_idx__=$(( ${#tmp_arr__[@]} - 1 ))
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
    declare -n tmp_arr__=$3
    min_idx__=$1

    if (($2 >= 0));then
      max_idx__=$(( min_idx__ + $2 - 1 ))
    elif (($2 < 0));then
      max_idx__=$(( ${#tmp_arr__[@]} + $2 - 1 ))
    fi
  fi

  if ((min_idx__ < 0));then
    min_idx__=$(( ${#tmp_arr__[@]} + min_idx__ ))
  fi

  if (( max_idx__ < 0 ));then
    max_idx__=$(( ${#tmp_arr__[@]} + max_idx__ ))
  fi

  subarr_len__=$((max_idx__ - min_idx__ + 1))
  ((subarr_len__ < 0)) && {
    echo "range error"
    return 1
  }

  arr_name__=("${tmp_arr__[@]:${min_idx__}:${subarr_len__}}")
}

### test func
slice_test()(
  cd "$(dirname "$(realpath "${BASH_SOURCE[0]}")")" || return
  [ -x "./../zoo/assert.sh" ] && source "./../zoo/assert.sh"

  local test_arr__=(0 1 2 3 4 5 6 7 8 9 0 a b c d e f g h)
  local res_arr__
  slice -v res_arr__ 7 test_arr__
  assert_arr_eq res_arr__ "(7 8 9 0 a b c d e f g h)" "slice 1"
  slice -v res_arr__ 7 0 test_arr__
  assert_arr_eq res_arr__ "()" "slice 2"
  slice -v res_arr__ 7 2 test_arr__
  assert_arr_eq res_arr__ "(7 8)" "slice 3"
  slice -v res_arr__ 7 -2 test_arr__
  assert_arr_eq res_arr__ "(7 8 9 0 a b c d e f)" "slice 4"
  slice -v res_arr__ -7 test_arr__
  assert_arr_eq res_arr__ "(b c d e f g h)" "slice 5"
  slice -v res_arr__ -7 2 test_arr__
  assert_arr_eq res_arr__ "(b c)" "slice 6"
  slice -v res_arr__ -7 -2 test_arr__
  assert_arr_eq res_arr__ "(b c d e f)" "slice 7"
  slice -v res_arr__ test_arr__
  assert_arr_eq res_arr__ "(0 1 2 3 4 5 6 7 8 9 0 a b c d e f g h)" "slice 8"
  slice -v res_arr__ 1..3 test_arr__
  assert_arr_eq res_arr__ "(1 2 3)" "slice 9"
  slice -v res_arr__ 7.. test_arr__
  assert_arr_eq res_arr__ "(7 8 9 0 a b c d e f g h)" "slice 10"
  slice -v res_arr__ ..7 test_arr__
  assert_arr_eq res_arr__ "(0 1 2 3 4 5 6 7)" "slice 11"
  slice -v res_arr__ 1..-7 test_arr__
  assert_arr_eq res_arr__ "(1 2 3 4 5 6 7 8 9 0 a b)" "slice 12"
  slice -v res_arr__ -7.. test_arr__
  assert_arr_eq res_arr__ "(b c d e f g h)" "slice 13"
  slice -v res_arr__ ..-7 test_arr__
  assert_arr_eq res_arr__ "(0 1 2 3 4 5 6 7 8 9 0 a b)" "slice 14"
  slice -v res_arr__ -10..-7 test_arr__
  assert_arr_eq res_arr__ "(9 0 a b)" "slice 15"
)
[ "x$1" = "xtest" ] && slice_test; unset slice_test

export -f slice
#### function slice end #####

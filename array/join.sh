#!/usr/bin/env bash

########  function `join`: join array elements ########

#### function join start #####
# ! Desc: join array elements with specify sep__erator
# ! Usage: join [-v VAR] Array_Name [Sep]
# !   arr=(a b c d)
# !   join arr ,      # a,b,c,d
# !   join arr        # a b c d
# !   join arr '--'   # a--b--c--d
# !   join -v joined arr ','
# !   echo $joined    # a,b,c,d
# ! Note: you should pass an indexed array name,
# !       don't pass scalar variable and associative array
join(){
  [ $# -lt 1 ] && {
    echo "function \`${FUNCNAME[0]}' arguments wrong"
    return 1
  }

  # -v VAR?
  local var_flag__=0
  [ "x$1" = "x-v" ] && {
    var_flag__=1
    local var_name__=$2
    shift 2
  }

  local arr_name__
  declare -n arr_name__=$1
  local arr_max_idx__
  (( arr_max_idx__=${#arr_name__[@]} - 1 ))

  # default seperator: one space
  local sep__=${2:-" "}

  local joined_str__
  # join elements from idx=0 to idx=(max_idx-1)
  printf -v joined_str__ "%s${sep__}" "${arr_name__[@]:0:${arr_max_idx__}}"
  # join the last element
  printf -v joined_str__ "%s%s" "${joined_str__}" ${arr_name__[-1]}

  if [ $var_flag__ -eq 1 ];then
    printf -v ${var_name__} "%s" "${joined_str__}"
  else
    printf "%s" "${joined_str__}"
  fi
}

# test func
join_test()(
  cd "$(dirname "$(realpath "${BASH_SOURCE[0]}")")"
  [ -x "./../zoo/assert.sh" ] && source "./../zoo/assert.sh"
  arr=(a b c d)
  export arr
  assert_eq "$(join arr)" "a b c d" "join1"
  assert_eq "$(join arr ,)" "a,b,c,d" "join2"
  assert_eq "$(join arr --)" 'a--b--c--d' "join3"
)
[ "x$1" = "xtest" ] && join_test

export -f join
#### function join end #####

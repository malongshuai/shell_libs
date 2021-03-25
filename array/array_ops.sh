#!/usr/bin/env bash


########  function `new_arr`: create an array ########

#### function new_arr start #####
# ! Desc: create an array
# ! Usage: new_arr ARRAY STRING
# ! e.g.: 
# !   new_arr arr '(a b c)'
# !   #=> arr=(a b c)
new_arr(){
  [ $# -lt 2 ] && {
    echo "function \`${FUNCNAME[0]}' arguments wrong"
    return 1
  }

  local _arr__
  declare -n _arr__=$1
  shift

  local _str__="$1"

#  # trim leading and trailing whitespace first
#  shopt -s extglob
#  _str__="${_str__##+([[:space:]])}"
#  _str__="${_str__%%+([[:space:]])}"
#  shopt -u extglob
#
  if [ "x${_str__:0:1}" != "x(" ] || [ "x${_str__: -1:1}" != "x)" ];then
    echo "Usage: \`to_arr' ARRAY '(e1 e2 e3)'"
    return 1
  fi

  eval _arr__="$_str__"
#  # printf "%s\n" "${_arr__[@]}"
}

# test func
new_arr_test()(
  cd "$(dirname "$(realpath "${BASH_SOURCE[0]}")")"
  [ -x "./../zoo/assert.sh" ] && source ./../zoo/assert.sh

  new_arr arr1 '(a b c)'
  assert_arr_eq arr1 '(a b c)'   "new_arr 1"
)
[ "x$1" = "xtest" ] && new_arr_test

export -f new_arr
#### function new_arr end #####


########  function `push`: push elements to array ########

#### function push start #####
# ! Desc: push elements to array
# ! Usage: push ARRAY e1 e2 e3 ...
# ! e.g.: 
# !   push arr1 a b 'c d' e  # arr1=(a b "c d" e)
# !   push arr1 aa bb cc     # arr1=(a b "c d" e aa bb cc)
# ! Note: 
# !   # `push' worked for indexed array, 
# !      but also worked for associative array,
# !      when ARRAY is an associative array, the order of 
# !      elements pushed in isn't guaranteed
push(){
  [ $# -lt 2 ] && {
    echo "function \`${FUNCNAME[0]}' arguments wrong"
    return 1
  }

  local arr__
  declare -n arr__="$1"
  shift

  local e
  for e in "${@}";do
    arr__[${#arr__[@]}]="${e}"
  done
}

# test func
push_test()(
  cd "$(dirname "$(realpath "${BASH_SOURCE[0]}")")"
  [ -x "./../zoo/assert.sh" ] && source ./../zoo/assert.sh
  local arr1
  declare -a arr1
  push arr1 a b 'c d' e
  assert_arr_eq arr1 '(a b "c d" e)'   "push1"

  push arr1 aa bb cc
  assert_arr_eq arr1 '(a b "c d" e aa bb cc)' "push2"
)
[ "x$1" = "xtest" ] && push_test

export -f push
#### function push end #####



########  function `extend`: extend array ########

#### function extend start #####
# ! Desc: extend array
# ! Usage: 
# !    extend ARRAY ARRAY1 ARRAY2 ...
# !    extend ARRAY String1 String2 ...
# ! Note: String will try to convert to an array
# ! e.g.: 
# !   arr1=(a b c)
# !   extend arr arr1       # arr=(a b c)
# !   arr2=(aa bb cc)
# !   arr3=(d "e e" f)
# !   extend arr arr2 arr3  # arr=(a b c aa bb cc d "e e" f)
# !   extend arr9 '(a b c)' '(d e)' arr1
# !   #=> arr9=(a b c d e a b c)
extend(){
  [ $# -lt 2 ] && {
    echo "function \`${FUNCNAME[0]}' arguments wrong"
    return 1
  }

  local _arr__
  declare -n _arr__="$1"
  shift

  local _a__
  local _e__
  for _a__ in "${@}";do
    # trim leading and trailing whitespace first
#    shopt -s extglob
#    _a__="${_a__##+([[:space:]])}"
#    _a__="${_a__%%+([[:space:]])}"
#    shopt -u extglob

    # if given parameter likes '(e1 e2 e3 ...)', convert it to array
    if [ "x${_a__:0:1}" == "x(" ] && [ "x${_a__: -1:1}" == "x)" ];then
      eval _arr__+="${_a__}"
    else  # given parameter is array name
      local _tmp_arr__
      declare -n _tmp_arr__="$_a__"
      for _e__ in "${_tmp_arr__[@]}";do
        _arr__[${#_arr__[@]}]="${_e__}"
      done
      # To reset `for' iteration pointer,
      # cancel the reference attribute
      declare +n _tmp_arr__
    fi
  done
}

# test func
extend_test(){
  (
    cd "$(dirname "$(realpath "${BASH_SOURCE[0]}")")"
    [ -x "./../zoo/assert.sh" ] && source ./../zoo/assert.sh
    local arr1=(a b c)
    local arr
    extend arr arr1
    assert_arr_eq arr '(a b c)'   "extend1"

    local arr2=(aa bb cc)
    local arr3=(d "e e" f)
    extend arr arr2 arr3
    assert_arr_eq arr '(a b c aa bb cc d "e e" f)'   "extend2"

    local xyz1
    extend xyz1 '(a "b c" d)' '(aa bb)' '(aa bb)'
    assert_arr_eq xyz1 '(a "b c" d aa bb aa bb)'   "extend3"

    local x1=(aa bb)
    local xyz2
    extend xyz2 '(a "b c" d)' x1 x1
    assert_arr_eq xyz2 '(a "b c" d aa bb aa bb)'   "extend4"
  )
}
[ "x$1" = "xtest" ] && extend_test

export -f extend
#### function extend end #####


########  function `pop`: pop array ########

#### function pop start #####
# ! Usage: pop [-v VAR] Array
# !   Default: remove the last element of array
# !            and print the removed element
# !   -v VAR: assign the poped element to shell
# !           variable VAR, rather than print it
# !   Note: if Array is empty, exit code 1.
pop(){
  local var_flag__=0
  [ "x$1" ==  "x-v" ] && {
    var_flag__=1
    local var_name__=$2
    shift 2
  }

  [ $# -ne 1 ] && {
    echo "function \`${FUNCNAME[0]}' arguments wrong"
    return 1
  }

  local arr__
  declare -n arr__="$1"

  if [ ${#arr__[@]} -eq 0 ];then
    return 1
  fi

  if [ $var_flag__ -eq 1 ];then
    printf -v "$var_name__" "%s" "${arr__[-1]}"
  else
    printf "%s" "${arr__[-1]}"
  fi

  unset 'arr__[-1]'
}

# test func
pop_test()(
  cd "$(dirname "$(realpath "${BASH_SOURCE[0]}")")"
  [ -x "./../zoo/assert.sh" ] && source ./../zoo/assert.sh
  local arr=(aa bb "c dd")
  local s
  pop -v s arr
  assert_eq "$s" "c dd" "pop1"
  assert_arr_eq arr '(aa bb)' "pop1"
)
[ "x$1" = "xtest" ] && pop_test

export -f pop
#### function pop end #####


########  function `shift_arr`: shift_arr array ########

#### function shift_arr start #####
# ! Usage: shift_arr [-v VAR] Array
# !   Default: remove the first element of array
# !            and print the removed element
# !   -v VAR: assign the removed element to shell
# !           variable VAR, rather than print it
# !   Note: if Array is empty, exit code 1.
shift_arr(){
  local var_flag__=0
  [ "x$1" ==  "x-v" ] && {
    var_flag__=1
    local var_name__=$2
    shift 2
  }

  [ $# -ne 1 ] && {
    echo "function \`${FUNCNAME[0]}' arguments wrong"
    return 1
  }

  local arr__
  declare -n arr__="$1"

  if [ ${#arr__[@]} -eq 0 ];then
    return 1
  fi

  if [ $var_flag__ -eq 1 ];then
    printf -v "$var_name__" "%s" "${arr__[0]}"
  else
    printf "%s" "${arr__[0]}"
  fi

  # unset first element, and left move all elements
  unset 'arr__[0]'
  arr__=("${arr__[@]}")
}

# test func
shift_arr_test()(
  cd "$(dirname "$(realpath "${BASH_SOURCE[0]}")")"
  [ -x "./../zoo/assert.sh" ] && source ./../zoo/assert.sh
  local arr=(aa bb "c dd" ee)
  local s
  shift_arr -v s arr
  assert_eq "$s" "aa" "shift_arr1"
  assert_arr_eq arr '(bb "c dd" ee)' "shift_arr1"
)
[ "x$1" = "xtest" ] && shift_arr_test

export -f shift_arr
#### function shift_arr end #####




########  function `unshift`: unshift array ########

#### function unshift start #####
# ! Usage:  unshift Array e1 [e2 e3 ...]
unshift(){
  [ $# -lt 2 ] && {
    echo "function \`${FUNCNAME[0]}' arguments error"
    return 1
  }

  local arr_name__
  declare -n arr_name__="$1"
  shift

  local _tmp_arr__=("$@")
  _tmp_arr__+=("${arr_name__[@]}")
  arr_name__=("${_tmp_arr__[@]}")
}

### test func
unshift_test()(
  cd "$(dirname "$(realpath "${BASH_SOURCE[0]}")")"
  [ -x "./../zoo/assert.sh" ] && source ./../zoo/assert.sh
  local arr1
  unshift arr1 "a"
  assert_arr_eq arr1 '(a)' "unshift1"

  local arr2
  unshift arr2 "a" "b" "c"
  assert_arr_eq arr2 '(a b c)'
)
[ "x$1" == "xtest" ] && unshift_test


export -f  unshift
#### function unshift end #####

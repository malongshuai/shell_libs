#!/usr/bin/env bash

######## function `index`: find substr index in string ########

#### function index start #####
# ! Desc: find substr in string
# ! Usage: index [-v VAR] [-r] Substr String
# !   Default: search Substr in String from left to right,
# !            if not found, index set to `-1'
# !    -v VAR: assign Substr index to shell variable
# !    -r    : search from right to left
# ! e.g.
# !   index 'ab' 'abcdab'      # 0
# !   index 'ab' 'ABabcdab'    # 2
# !   index 'a b' 'ABa bcdab'  # 2
# !   index 'a b' 'ABabcdab'   # -1
# !   index -r 'ab' 'abcd'     # 0
# !   index -r 'ab' 'abcdab'   # 4
# !   index -r 'a b' 'abcda b' # 4
# !   index -r 'a b' 'abcdab'  # -1
index(){
  [ $# -lt 2 ] && {
    echo "function \`${FUNCNAME[0]}' arguments wrong"
    return 1
  }

  local rindex__=0
  local var_flag__=0
  while [ $# -gt 2 ];do
    case "$1" in
      -r)
        rindex__=1;shift;;
      -v)
         var_flag__=1;
         local var_name__=$2
         shift 2;;
      *)
        echo "function \`${FUNCNAME[0]}' arguments wrong"
        return 1
    esac
  done

  local substr__="$1"
  local substr_len__=${#substr__}
  local str__="$2"
  local str_len__=${#str__}

  local idx__
  local _str__
  
  # if substr not found in string, idx=-1
  if [ $rindex__ -eq 1 ];then
    _str__="${str__%${substr__}*}"
    [ ${#_str__} -ne ${#str__} ] \
      && idx__=$(( ${#_str__} )) \
      || idx__=-1
  else
    _str__="${str__#*${substr__}}"
    [ ${#_str__} -ne ${#str__} ] \
     && idx__=$(( (str_len__ - ${#_str__} - substr_len__) )) \
     || idx__=-1
  fi

  if [ $var_flag__ -eq 1 ];then
    printf -v $var_name__ "%s" $idx__
  else
    printf "%s" $idx__
  fi
}

# test func
index_test()(
  cd "$(dirname "$(realpath "${BASH_SOURCE[0]}")")"
  [ -x "./../zoo/assert.sh" ] && source "./../zoo/assert.sh"
  assert_eq "$(index 'ab' 'abcdab')" 0 "index1"
  assert_eq "$(index 'ab' 'ABabcdab')" 2 "index2"
  assert_eq "$(index 'a b' 'ABa bcdab')" 2 "index3"
  assert_eq "$(index 'a b' 'ABabcdab')" -1 "index4"

  assert_eq "$(index -r 'ab' 'abcd')" 0 "rindex1"
  assert_eq "$(index -r 'ab' 'abcdab')" 4 "rindex2"
  assert_eq "$(index -r 'a b' 'abcda b')" 4 "rindex3"
  assert_eq "$(index -r 'a b' 'abcdab')" -1 "rindex4"

  index -v _var1 'ab' 'abcdab'
  assert_eq "$_var1" 0 "index_var1"
  index -v _var2 -r 'ab' 'abcdab'
  assert_eq "$_var2" 4 "index_var2"
)
[ "x$1" = "xtest" ] && index_test

export -f index
#### function index end #####



######## function `index_all`: find all substr indices in string ########

#### function index_all start #####
# ! Desc: find all substr indices in string
# ! Usage: index_all [-v ARRAY] Substr String
# !   Default: search all indices of Substr in String
# !            print them or store them into array if 
# !            specified `-v' option,if Substr not 
# !            found, print nothing or array is empty
# !    -v VAR: assign Substr index to shell variable
# ! e.g.
# !   index_all 'ab' 'abcdab'    # `0 4' or '(0 4)'
# !   index_all 'ab' 'abcdabab'  # `0 4 6' or '(0 4 6)'
# !   index_all 'abx' 'def'      # '' or ()
index_all(){
  [ $# -lt 2 ] && {
    echo "function \`${FUNCNAME[0]}' arguments wrong"
    return 1
  }

  local var_flag__=0
  local arr_name__
  [ "x$1" = "x-v" ] && {
    var_flag__=1
    declare -n arr_name__=$2
    shift 2
  }

  local substr__="$1"
  local substr_len__=${#substr__}
  local str__="$2"
  local str_len__=${#str__}

  local i__=0
  while [ $i__ -le $((str_len__ - substr_len__)) ];do
    if [ "x${str__:$i__:$substr_len__}" = "x${substr__}" ];then
      arr_name__[${#arr_name__[@]}]=$i__
      ((i__+=substr_len__))
    else
      ((i__++))
    fi
  done

  if [ $var_flag__ -ne 1 ];then
    echo -n "${arr_name__[@]}"
  fi
}

# test func
index_all_test()(
  cd "$(dirname "$(realpath "${BASH_SOURCE[0]}")")"
  [ -x "./../zoo/assert.sh" ] && source "./../zoo/assert.sh"
  assert_eq "$(index_all 'ab' 'abcdab')" '0 4' "index_all1"
  assert_eq "$(index_all 'ab' 'abcdabc')" '0 4' "index_all2"
  assert_eq "$(index_all 'ab' 'abcdabcab')" '0 4 7' "index_all3"
  assert_eq "$(index_all 'ab' 'cdabcab')" '2 5' "index_all4"
  assert_eq "$(index_all 'axb' 'cdabcab')" '' "index_all5"

  index_all -v _arr1 'ab' 'abcdab'
  assert_arr_eq _arr1 '(0 4)' "index_all_var1"
)
[ "x$1" = "xtest" ] && index_all_test

export -f index_all
#### function index_all end #####

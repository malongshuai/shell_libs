#!/usr/bin/env bash

######## function `random_str`: generate random string ########

#### function random_str start #####
# ! Desc: generate random string
# ! Usage:
# !   random_str [-v Var]
# !   random_str [-v Var] [N]
# !   random_str [-v Var] [-lupn] [N]
random_str(){
  [ $# -gt 4 ] && {
    echo "function \`${FUNCNAME[0]}' arguments wrong"
    return 1
  }

  local cnt__=8      # default random string length: 8

  local var_flag__=0
  [ "x$1" == "x-v" ] && {
    var_flag__=1
    local var_name__=$2
    shift 2
  }

  local lower_arr__=({a..z})
  local upper_arr__=({A..Z})
  local num_arr__=({0..9})
  local punct_arr__=(\! \" \# \$ \% \& \' \( \) \* \+ \- \* \/ \. \, \; \: \< \> \= \? \@ \{ \} \| \~ \[ \] \\ \_ \`)
  local arr__=()

  if [ $# -gt 1 ];then
    # check option: -lpun

    local flag__="$1";
    shift;

    # option missing prefix '-', or includes other character
    shopt -s extglob
    [ x"${flag__/-+([lunp])/}" != "x" ] && {
      echo "function \`${FUNCNAME[0]}' arguments wrong"
      return 1
    }
    shopt -u extglob

    # option with 'l'
    [ x"${flag__/l/}" != "x${flag__}" ] && arr__=("${arr__[@]}" "${lower_arr__[@]}")

    # option with 'u'
    [ x"${flag__/u/}" != "x${flag__}" ] && arr__=("${arr__[@]}" "${upper_arr__[@]}")

    # option with 'n'
    [ x"${flag__/n/}" != "x${flag__}" ] && arr__=("${arr__[@]}" "${num_arr__[@]}")

    # option with 'p'
    [ x"${flag__/p/}" != "x${flag__}" ] && arr__=("${arr__[@]}" "${punct_arr__[@]}")
  fi

  [ $# -gt 0 ] && {
    if (( $1 + 0 )) &>/dev/null;then
      cnt__=$1
    else
      echo "function \`${FUNCNAME[0]}' arguments wrong"
      return 1
    fi
  }

  local str__=""
  local i__=0
  for((;i__ < cnt__ ; i__++));do
    str__="${str__}${arr__[((RANDOM % ${#arr__[@]}))]}"
  done

  if [ ${var_flag__} -eq 1 ];then
    printf -v ${var_name__} -- "%s" "${str__}"
  else
    printf -- "%s" "${str__}"
  fi
}

export -f random_str
#### function random_str end #####
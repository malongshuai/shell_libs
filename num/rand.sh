#!/usr/bin/env bash

######## function `rand`: get random integer ########

#### function rand start #####
# ! Desc: get random integer
# ! Usage: rand [-v Var] [N]
# !   -v Var: assign random integer to shell variable
# !        N: get random between 0 and N. When omit N
# !           default get random in range [0, 32767].
rand(){
  local var_flag__=0
  [ "x$1" == "x-v" ] && {
    var_flag__=1
    local var_name__=$2
    shift 2
  }

  [ $# -gt 2 ] && {
    echo "\`${FUNCNAME[0]}' arguments wrong"
    return 1
  }

  # default random range: [0, 32767]
  local n__=32767
  (($1+0)) &>/dev/null && n__=$1

  if [ ${var_flag__} -eq 1 ]; then
    printf -v "${var_name__}" "%d" $(( RANDOM % n__ ))
  else
    printf "%d" $(( RANDOM % n__ ))
  fi
}

export -f rand
#### function rand end #####


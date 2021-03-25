########  function `repeat_str`: repeat str some times ########

#### function repeat_str start ####
# Usage: repeat_str [-v VAR] Str N
#   N: must be integer, and great than 0
#  -v: assign repeated str to shell variable VAR, 
#      rather than output it
function repeat_str(){
  [ $# -lt 2 ] && {
    warn "Usage: $FUNCNAME Str n_times"
    return 1
  }

  local var_flag=0
  [ "x$1" == "x-v" ] && {
    var_flag=1
    local var_name=$2
    shift 2
  }
  local str=$1

  # cnt must be integer and great than 0
  local cnt
  declare -i cnt
  cnt=$2
  [ $cnt -le 0 ] && return

  if [ $var_flag -eq 1 ];then
    eval printf -v $var_name -- "$str%.0s" {1..$cnt}
  else
    eval printf -- "$str%.0s" {1..$cnt}
  fi
}

#### test
if [ "x$1" == "xtest" ];then
  [ -x "./assert.sh" ] && source ./assert_sh
  assert_eq "repeat_str - 5" "-----" "msg"
  assert_eq "repeat_str ab 3" "ababab"
  return
fi

export -f repeat_str
#### function repeat_str end ####

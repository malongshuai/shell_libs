########  function `junmajinlong_say`: junmajinlong say something ########

#### function junmajinlong_say start ####
# Usage 1:
#   $0 "hello" 30
#     get: ----------- hello ------------
#   $0 "hello"
#     get: ---------------- hello --------------------
#     defalut length: 80
#
# Usage 2:
#   source $0
# after source, function `junmajinlong_say` is available
#   junmajinlong_say "hello" 30
#   junmajinlong_say "hello"
#   junmajinlong_say -v var "hello"  # set str to variable `var`
#   echo $var

function junmajinlong_say_Usage() {
  cat <<'eof'
+--------------------------------------------------------------+
|Usage:                                                        |
+--------------------------------------------------------------+
| As a Command: junmajinlong_say.sh "what to say" [Str_len]    |
|   Str_len: the length of line, default 80                    |
+--------------------------------------------------------------+
| As a SourceScript: source junmajinlong_say.sh                |
|   After source, you can call function `junmajinlong_say`     |
|                                                              |
|   function `junmajinlong_say` Usage:                         |
|     junmajinlong_say [-v var] "what_to_say" [Str_len]        |
|                                                              |
|     -v var: like bash printf -v var or C sprintf, str will   |
|             store to variable `var`                          |
+--------------------------------------------------------------+
eof
}

[ "x$1" == "x--help" ] && { junmajinlong_say_Usage; exit 1; }

function junmajinlong_say(){
  [ $# -eq 0 ] && junmajinlong_say_Usage

  local var_flag=0
  [ "x$1" == "x-v" ] && {
    var_flag=1
    local var_name=$2
    shift 2
  }

  local what_to_say="$1"
  how_long=${2:-80}
  local msg_len=${#what_to_say}

  local left_cnts=$(( ($how_long - $msg_len - 2 ) / 2 ))
  local right_cnts=$left_cnts

  local left_str_to_printf;
  repeat_str -v left_str_to_printf '-' $left_cnts
  local right_str_to_printf;
  repeat_str -v right_str_to_printf '-' $right_cnts

  if [ $var_flag -eq 1 ];then
    printf -v $var_name "%s %s %s" "${left_str_to_printf}" "$what_to_say" "${right_str_to_printf}"
  else
    printf "%s %s %s" "${left_str_to_printf}" "$what_to_say" "${right_str_to_printf}"
  fi
}

# test func
if [ "x$1" = "xtest" ];then
  [ -x "./assert.sh" ] && source ./assert_sh
  assert_eq 'junmajinlong_say hello 30' "----------- hello -----------"
  return
fi

export -f junmajinlong_say
#### function junmajinlong_say end ####

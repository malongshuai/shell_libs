#!/usr/bin/env bash

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

junmajinlong_say_Usage() {
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

junmajinlong_say(){
  [ $# -eq 0 ] && junmajinlong_say_Usage

  local var_flag__=0
  [ "x$1" == "x-v" ] && {
    var_flag__=1
    local var_name__=$2
    shift 2
  }

  local what_to_say__="$1"
  local how_long__=${2:-80}
  local msg_len__=${#what_to_say__}

  local left_cnts__=$(( (how_long__ - msg_len__ - 2 ) / 2 ))
  local right_cnts__=$left_cnts__

  local left_str_to_printf__;
  eval printf -v left_str_to_printf__ -- "-%.0s" "{1..${left_cnts__}}"
  local right_str_to_printf__;
  eval printf -v right_str_to_printf__ -- "-%.0s" "{1..${right_cnts__}}"

  if [ $var_flag__ -eq 1 ];then
    printf -v $var_name__ "%s %s %s" "${left_str_to_printf__}" "$what_to_say__" "${right_str_to_printf__}"
  else
    printf "%s %s %s" "${left_str_to_printf__}" "$what_to_say__" "${right_str_to_printf__}"
  fi
}

# test func
junmajinlong_say_test()(
  cd "$(dirname "$(realpath "${BASH_SOURCE[0]}")")"
  [ -x "./../zoo/assert.sh" ] && source "./../zoo/assert.sh"
  assert_eq "$(junmajinlong_say hello 30)" "----------- hello -----------" "junmajinlong_say"
)
[ "x$1" = "xtest" ] && junmajinlong_say_test

export -f junmajinlong_say
#### function junmajinlong_say end ####

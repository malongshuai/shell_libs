#!/usr/bin/env bash

########  function `squash`: squash sequences char in string ########

#### function squash start #####
# ! Desc: squash sequences char in string
# ! Usage: squash [-v VAR] [-s] [Squash_char] str
# !   Default: trim leading and trailing specified Squash_char,
# !            then squash those Suqash_cahr(s) to single
# !   -s: don't trim leading and trailing beforce squashing
# !   -v: assign squashed str to shell variable VAR
# !  Squash_char: specify which char will be squashed,
# !               only take the first char in Squash_char
# !               for squashing, if omit, default to whitespace
# ! e.g.
# !   squash  '  a  b  c  '        # "a b c"
# !   squash -s '  a  b  c  '      # " a b c "
# !   squash "," ',,,a,,b,,c,,'    # "a,b,c"
# !   squash -s "," ',,,a,,b,,c,,' # ",a,b,c,"
# !   squash -s ",-" ',,-a,,--b,,c,,' # ",-a,--b,c,"
squash(){

  [ $# -lt 1 ] && {
    echo "\`${FUNCNAME[0]}' argument wrong"
    return 1
  }

  local squash_all__=1  # default squash all space
  local squash_char__='[:space:]' # default squash whitespaces
  local var_flag__=0

  while [ $# -gt 1 ];do
    case "$1" in 
      -s)
        squash_all__=0;shift;;
      -v)
        var_flag__=1;
        local var_name__=$2;
        shift 2;;
      *)
        # squash only the first char, ignore other chars,
        squash_char__="${1:0:1}"
        shift
        # if remain args more than two, that's wrong
        [ $# -gt 1 ] && {
          echo "\`${FUNCNAME[0]}' argument wrong"
          return 1
        }
    esac
  done

  local str__="$1"

  # first: trim leading and trailing chars
  if [ $squash_all__ -eq 1 ];then
    # trim leading chars
    str__="${str__#"${str__%%[^${squash_char__}]*}"}"
    # trim trailing chars
    str__="${str__%"${str__##*[^${squash_char__}]}"}"
  fi

  # then: squash chars
  shopt -s extglob
  if [ "x${squash_char__}" = "x[:space:]" ];then
    str__="${str__//+([${squash_char__}])/ }"
  else
    str__="${str__//+([${squash_char__}])/${squash_char__}}"
  fi
  shopt -u extglob


  if [ $var_flag__ -eq 1 ];then
    printf -v $var_name__ "%s" "${str__}"
  else
    printf "%s" "${str__}"
  fi
}


# test func
squash_test()(
  cd "$(dirname "$(realpath "${BASH_SOURCE[0]}")")"
  [ -x "./../zoo/assert.sh" ] && source "./../zoo/assert.sh"
  assert_eq "$(squash "  a  b  c  " )" "a b c"  "squash1"
  assert_eq "$(squash -s "  a  b  c  " )" " a b c "  "squash2"

  assert_eq "$(squash -s " " "  a  b  c  " )" " a b c "  "squash3"
  assert_eq "$(squash    "," ",,a,,b,,c,," )" "a,b,c"  "squash4"
  assert_eq "$(squash -s "," ",,a,,b,,c,," )" ",a,b,c,"  "squash5"
  assert_eq "$(squash -s ",-" ',,-a,,--b,,c,,' )" ",-a,--b,c,"  "squash6"
)
[ "x$1" = "xtest" ] && squash_test

export -f squash
#### function squash end #####

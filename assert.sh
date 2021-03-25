########  function `assert_eq`: test cmd output ########

#### function assert_eq start ####
function ___msg()    { echo -e "${BLUE}  ${1}${RESET}"; }
function ___ok()     { echo -e "${GREEN}${1} ${RESET}"; }
function ___not_ok() { echo -e "${RED_BOLD}${RED}$1${RESET}"; }

## Usage:
##   assert_eq cmd val1
##   assert_eq cmd val1 error_message
function assert_eq(){
  [ $# -lt 2 ] && error "argument wrong"
  local cmd=$1
  local cmd_name=${cmd%% *}
  local val="$2"
  local message="$3"
  local cmd_res="$($cmd)"
  if [ "x$cmd_res" == "x${val}" ];then
    ___ok "${cmd_name}..............ok"
    return 0
  else
    ___not_ok "${cmd_name}..............not ok"
    echo "Exec Res: $cmd_res"
    echo "Expect Res: $val"
    [ "$message" ] && ___msg "$message"
    return 1
  fi
}

#### test myself
if [ "x$1" == "xtest" ];then
  assert_eq "echo hello world" "hello world" "msg"
  assert_eq "echo hello world" "hello worl"
  assert_eq "echo hello world" "hello worl"  "msg"
  return
fi

export -f assert_eq
#### function assert_eq end ####

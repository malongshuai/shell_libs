######## function `require`: require shell libs #########

#### function require start ####
# Usage: require 'PATH_TO_SHELL_LIB'
function require(){
  local path="$1"
  local real_path="$(realpath "$path")"
  # require a shell lib only one time
  # all required lib will record to array `___required_path_arr`
  declare -p ___required_path_arr &>/dev/null || declare -gA ___required_path_arr
  if [ -x "$path" -a $((___required_path_arr["${real_path}"])) -eq 0 ];then
    source "$path" && ___required_path_arr["${real_path}"]=1
    echo "已加载库: $real_path"
  fi
}
export -f require
#### function require end ####

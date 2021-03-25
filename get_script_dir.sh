########  function `get_script_dir`: get the scirpt dirname ########

#### function get_script_dir start ####
# Usage: display the directory of current script
#  1. if this function used in sourcing script, 
#       get_script_dir -s
#  2. if this function used in binary shell script,
#       get_script_dir
function get_script_dir(){
  # for i in "${BASH_SOURCE[@]}";do echo $i; done
  local sourced=0
  [ "x$1" = "x-s" ] && sourced=1
  if [ $sourced -eq 1 ];then
    dirname "$(realpath "${BASH_SOURCE[1]}")"
  else
    dirname "$(realpath "${BASH_SOURCE[-1]}")"
  fi
}

export -f get_script_dir
#### function get_script_dir end ####

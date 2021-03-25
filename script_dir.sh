########  function `script_dir`: get the scirpt dirname ########

#### function script_dir start ####
function script_dir(){
  # for i in "${BASH_SOURCE[@]}";do echo $i; done
  dirname "$(realpath "${BASH_SOURCE[-1]}")"
}
export -f script_dir
#### function script_dir end ####

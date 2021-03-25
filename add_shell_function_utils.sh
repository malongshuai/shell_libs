#!/bin/bash

# 1.执行本脚本
#   将生成shell脚本库加载器/etc/profile.d/shell_function_utils.sh，
#   同时会拷贝shell脚本库到/etc/profile.d/utils目录，
# 2.source /etc/profile.d/shell_function_utils.sh
# 3.使用shell脚本库函数，例如 repeat_str 

utils_dir="/etc/profile.d/utils"
utils_load_path="/etc/profile.d/shell_function_utils.sh"

[ -x "${utils_dir}" ] || sudo mkdir "$utils_dir"

[ -x "${utils_load_path}" ] || {
  sudo touch "$utils_load_path"
  sudo chmod +x "$utils_load_path"
  sudo bash -c "cat >${utils_load_path}" <<EOF
#!/bin/bash
for lib in ${utils_dir}/*;do
  source \$lib
done

EOF
}

# 拷贝脚本库到/etc/profile.d/utils目录下
(
  cd "$(dirname "$(realpath "$0")" )"
  shscripts=(
    colorize_output.sh
    require.sh
    assert.sh
    junmajinlong_say.sh
    get_script_dir.sh
    repeat_str.sh
    winpath2unixpath.sh
  )
  for sh in "${shscripts[@]}";do
    sudo /bin/cp -fv $sh "${utils_dir}"
    sudo chmod +x "${utils_dir}/${sh}"
  done
)



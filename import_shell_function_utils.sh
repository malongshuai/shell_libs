#!/bin/bash

# 1.执行本脚本
#   将生成shell脚本库加载器/etc/profile.d/import_shell_function_utils.sh，
#   同时会拷贝shell脚本库到/etc/profile.d/utils目录，
# 2.source /etc/profile.d/import_shell_function_utils.sh
# 3.使用shell脚本库函数，例如 repeat_str 

utils_dir="/etc/profile.d/utils"
utils_load_path="/etc/profile.d/import_shell_function_utils.sh"

sudo rm -rf "${utils_dir}" && sudo mkdir "$utils_dir"

[ -x "${utils_load_path}" ] || {
  sudo touch "$utils_load_path"
  sudo chmod +x "$utils_load_path"
  sudo bash -c "cat >${utils_load_path}" <<EOF
#!/bin/bash
extglob_flag__=0
shopt -q extglob || extglob_flag__=1
[ \$extglob_flag__ -eq 1 ] && shopt -s extglob
for lib in ${utils_dir}/**/*.sh;do
  source \$lib
done
[ \$extglob_flag__ -eq 1 ] && shopt -u extglob
unset extglob_flag__
EOF
}

# 拷贝脚本库到/etc/profile.d/utils目录下
(
  cd "$(dirname "$(realpath "$0")" )"
  sudo /bin/cp -fav ./* "${utils_dir}"
  sudo rm -rf "/etc/profile.d/utils/import_shell_function_utils.sh"
  sudo chmod -R +x "${utils_dir}"
)



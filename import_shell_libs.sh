#!/bin/bash

# 1.执行本脚本
#   将生成shell脚本库加载器/etc/profile.d/import_shell_libs.sh，
#   同时会拷贝shell脚本库到/etc/profile.d/shell_libs目录，
# 2.source /etc/profile.d/import_shell_libs.sh
# 3.使用shell脚本库函数，例如 repeat_str 

utils_dir="/etc/profile.d/shell_libs"
utils_load_path="/etc/profile.d/import_shell_libs.sh"

sudo rm -rf "${utils_dir}" && sudo mkdir "$utils_dir"

[ -x "${utils_load_path}" ] || {
  sudo touch "$utils_load_path"
  sudo chmod +x "$utils_load_path"
  sudo bash -c "cat >${utils_load_path}" <<EOF
#!/bin/bash

if shopt -q extglob;then
  for lib in ${utils_dir}/**/*.sh;do
    source \$lib
  done
else
  shopt -s extglob
  for lib in ${utils_dir}/**/*.sh;do
    source \$lib
  done
  shopt -u extglob
fi
EOF
}

# 拷贝脚本库到/etc/profile.d/utils目录下
(
  cd "$(dirname "$(realpath "$0")" )"
  find . -mindepth 1 -type d -not -path "*/.*" | sudo xargs -i /bin/cp -fav {} "${utils_dir}"
#  sudo /bin/cp -fav ./!(import_shell_libs.sh) "${utils_dir}"
  sudo rm -rf "/etc/profile.d/utils/import_shell_libs.sh"
  sudo chmod -R +x "${utils_dir}"
)



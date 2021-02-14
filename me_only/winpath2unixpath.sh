#!/usr/bin/env bash

########  function `winpath2unixpath`: change winpath to unixpath ########

#### function winpath2unixpath start ####

#Usage: winpath2unixpath0 winpath [prefix]
#e.g.
#    winpath2unixpath 'E:\onedrive\docs\blog_imgs\2020'
#    winpath2unixpath 'E:\onedrive\docs\blog_imgs\2020' /mnt
winpath2unixpath(){
  local path__="$1"
  local p__=${path__//\\/\/}
  # 路径中不包含冒号，说明是unix路径或没有Win
  # 盘符的相对路径，直接输出
  [ "x$path__" != "x${path__%%:*}" ] && {
    # 路径中包含冒号，去除冒号，将盘符转为小写，加上前缀
    local path_prefix__="${2:-/mnt}"
    p__="${p__//:/}"
    p__="$path_prefix__"/"${p__,}"
  }
  echo "$p__";
}

# test func
winpath2unixpath_test()(
  cd "$(dirname "$(realpath "${BASH_SOURCE[0]}")")"
  [ -x "./../zoo/assert.sh" ] && source "./../zoo/assert.sh"
  assert_eq "$(winpath2unixpath 'E:\a\b\c' /mnt)" "/mnt/e/a/b/c" 'winpath2unixpath1'
  assert_eq "$(winpath2unixpath 'E:\a\b\c' /abc)" "/abc/e/a/b/c" 'winpath2unixpath2'
  assert_eq "$(winpath2unixpath 'a\b\c')" "a/b/c" 'winpath2unixpath3'
  assert_eq "$(winpath2unixpath /a/b/c)" "/a/b/c" 'winpath2unixpath4'
)
[ "x$1" = "xtest" ] && winpath2unixpath_test

export -f winpath2unixpath
#### function winpath2unixpath end ####
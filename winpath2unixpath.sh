########  function `winpath2unixpath`: change winpath to unixpath ########

#### function winpath2unixpath start ####

#Usage: winpath2unixpath0 winpath [prefix]
#e.g.
#    winpath2unixpath 'E:\onedrive\docs\blog_imgs\2020'
#    winpath2unixpath 'E:\onedrive\docs\blog_imgs\2020' /mnt
function winpath2unixpath(){
  local path="$1"
  p=${path//\\/\/}
  # 路径中不包含冒号，说明是unix路径或没有Win
  # 盘符的相对路径，直接输出
  [ "x$path" != "x${path%%:*}" ] && {
    # 路径中包含冒号，去除冒号，将盘符转为小写，加上前缀
    local path_prefix="${2:-/mnt}"
    p="${p//:/}"
    p="$path_prefix"/"${p,}"
  }
  echo "$p";
}

# test func
if [ "x$1" = "xtest" ];then
  [ -x "./assert.sh" ] && source ./assert_sh
  assert_eq 'winpath2unixpath E:\a\b\c /mnt' "/mnt/e/a/b/c"
  assert_eq "winpath2unixpath E:\a\b\c /abc" "/abc/e/a/b/c"
  assert_eq "winpath2unixpath a\b\c" "a/b/c"
  assert_eq "winpath2unixpath /a/b/c" "/a/b/c"
  return
fi

export -f winpath2unixpath
#### function winpath2unixpath end ####
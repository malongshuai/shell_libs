# Shell(Bash)库函数

这些库函数完全使用bash内置命令和bash自身特性编写，未使用任何外部命令，且除了测试库函数，其他所有库函数都未使用任何影响效率的行为(例如命令替换、进程替换、管道导致的额外进程，等等)，因此，效率在shell层次上是有保证的。

这些库函数可以作为一个不错的学习和深入理解bash内置特性的途径。

欢迎issue提出问题。

# 用法

先下载或克隆：
```bash
git clone https://github.com/malongshuai/shell_libs.git
cd shell_libs
```

执行`import_shell_function_utils.sh`：
```bash
bash import_shell_function_utils.sh
```
这将会拷贝所有的库函数文件(除`import_shell_function_utils.sh`外)到`/etc/profile.d/utils`目录，并生成`/etc/profile.d/import_shell_function_utils.sh`文件，该文件用于加载拷贝到utils目录下的所有库文件。

重新登录bash(以及以后每次登录bash)，将加载这些库函数文件。
```bash
exec bash
```

现在可以使用这些库函数。例如使用库函数rand生成指定范围内的随机整数：
```bash
rand 100   # 生成0到100(不包括100)之间的随机整数
```

如果要在脚本中使用这些库函数，则在脚本中加上如下一行手动source加载库文件。
```bash
source /etc/profile.d/import_shell_function_utils.sh
```

# 库函数文档

说明：这些库函数中，可以输出结果的库函数，也都可以使用`-v Var`将结果赋值给shell变量而不输出。

例如：
```bash
upcase "hello world"
```
将输出`HELLO WORLD`。

```bash
upcase -v big "hello world"
```
不会输出，而是将`HELLO WORLD`赋值给shell变量big。

因此，下面两条命令在效果上是等价的，都将大写后的字符串赋值给变量big，但后者效率更高：
```bash
big="$(upcase "hello world")"
upcase -v big "hello world"
```

## 数值类库函数

包括如下几个数值类的库函数：  
- is_int：判断给定参数是否是整数  
- rand：生成给定范围的随机整数  

### is_int

判断给定参数是否是整数。如果给定参数是整数，退出状态码为0，否则退出状态码为1。

```bash
# 下面几个命令的退出状态码为0
is_int 3
is_int 2312
is_int 033     # 判断8进制整数
is_int 0x33    # 判断16进制整数
is_int 0b1001  # 判断二进制整数

# 下面几个命令的退出状态码为1
is_int ab
is_int     # 无参数
```

### rand

```bash
rand [-v Var] [N]
```

生成指定范围0-N(不包括N)之间的随机整数。如果省略N，则等价于bash RANDOM变量，生成0-32767范围内的随机整数。

默认输出所生成的随机整数，使用`-v Var`选项，可将生成的随机整数赋值给shell变量而不是输出。

```bash
rand   # 输出0-32767之间的随机整数
rand 10  # 输出0-10之间的随机整数

rand -v r 100 # 生成0-100之间的随机整数并赋值给变量r
```

## 数组类库函数

bash的数组可以是数值索引数组，也可以字符串索引的关联数组(即hash结构)。此处所列功能皆为数值索引数组而设计，虽然部分也可以应用于关联数组，但结果不可预测。

包括如下几个数值索引数组类的库函数：  
- new_arr：根据指定格式的字符串构建数组  
- push：向数组尾部追加一个或多个元素  
- pop：移除数组最后一个元素，并输出该元素或将其赋值给指定的变量  
- unshift：向数组头部插入一个或多个元素  
- shift_arr：移除数组第一个元素，并输出该元素或将其赋值给指定的变量  
- extend：扩展数组  
- join：使用指定字符串连接数组各元素  

### new_arr

```bash
new_arr Arr_Name String
```

将给定的字符串String转换为数组Arr_Name。支持转换的String格式为`(elem1 elem2 elem3...)`。

建议：String部分使用引号保护。

例如：
```bash
$ new_arr arr '(a b c "d e")'
$ # 等价于 arr=(a b c "d e")
$ declare -p arr
declare -a arr=([0]="a" [1]="b" [2]="c" [3]="d e")
```

### push

```bash
push ARR e1 [e2 e3 ...]
```

向数组ARR尾部追加一个或多个元素。

例如：
```bash
push arr a b 'c d' e  # arr=(a b "c d" e)
push arr aa bb    # arr=(a b "c d" e aa bb)
```

### unshift

```bash
unshift Arr e1 [e2 e3 ...]
```

向数组Arr的头部插入一个或多个元素。如果插入的是多个元素，则一次性插入。

例如：
```bash
unshift arr "a"  # arr=(a)
unshift arr "a" "b" "c" # arr=(a b c a)
```

### pop

```bash
pop [-v Var] Arr
```

移除数组Arr最后一个元素，并输出该元素，或者指定`-v Var`选项将该元素赋值给shell变量Var而不再输出。如果数组Arr为空数组，则什么也不做，并且设置退出状态码为1。

例如：
```bash
arr=(a b c d)
pop arr   # 输出d，arr=(a b c)
pop -v l arr # 将c赋值给变量l，arr=(a b)
```

### shift_arr

```bash
shift_arr [-v Var] Arr
```

移除数组Arr第一个元素，并输出该元素，或者指定`-v Var`选项将该元素赋值给shell变量Var而不再输出。如果数组Arr为空数组，则什么也不做，并且设置退出状态码为1。

说明：因为bash已经内置了一个shift命令，shift命令用于操作位置参数。因此，该函数命名为shift_arr，表示操作数组的shift。

例如：
```bash
arr=(a b c d)
shift_arr arr  # 输出a，arr=(b c d)
shift_arr -v l arr # 将b赋值给变量l，arr=(c d)
```

### extend

```bash
extend Arr Arr1 Arr2 ...
extend Arr String1 String2 ...
```

扩展数组。可以将其他数组变量Arr1、Arr2的元素扩展到数组Arr中，也可以将字符串格式的数组(将使用`new_arr`将字符串转换为数组)扩展到数组Arr。

例如：
```bash
arr1=(a b c)
extend arr arr1       
#=> arr=(a b c)

arr2=(aa bb cc)
arr3=(d "e e" f)
extend arr arr2 arr3  
#=> arr=(a b c aa bb cc d "e e" f)

extend arr9 '(a b c)' '(d e)' arr1
#=> arr9=(a b c d e a b c)
```

### join

```bash
join [-v Var] Array_Name [Sep]
```

使用指定的字符串串联数组各元素，如果未指定连接符，则默认使用空格串联。使用`-v Var`选项可以将串联后的结果赋值给变量，否则将输出串联后的结果。

例如：
```bash
arr=(a b c d)
join arr ,      # 输出：a,b,c,d
join arr        # 输出：a b c d
join arr '--'   # 输出：a--b--c--d
join -v joined arr ',' # joined='a,b,c,d'
```

## 字符串类库函数

包括如下几个字符串类的库函数：  
- downcase：将字符串转换为小写  
- upcase：将字符串转换为大写  
- repeat_str：重复字符串指定次数  
- center：将字符串居中  
- trim：根据指定的字符串，修剪字符串中左右两边的字符  
- squash：压缩连续的指定字符  
- split：根据指定分隔符，将字符串划分为数组  
- index：搜索字符串中指定子串第一次出现的索引位置  
- index_all：搜索字符串中指定子串的所有索引位置  
- chars：将字符串每个字符保存到数组  
- str_slice：获取字符串的子串  

### downcase和upcase

```bash
downcase [-v Var] Str
upcase [-v Var] Str
```

将字符串转换为大写、小写。默认将输出转换后的字符串，指定`-v Var`选项，转换后的字符串将赋值给变量而非输出。

例如：
```bash
downcase 'HELLO WORLD' # 输出："hello world"
upcase -v upstr 'hello world'  # upstr="HELLO WORLD"
```

### repeat_str

```bash
repeat_str [-v Var] Str N
```

重复字符串N次(N为正整数)。指定`-v Var`可将重复后的字符串赋值给变量，否则将输出重复后的字符串。

例如：
```bash
repeat_str - 5        # 输出："-----"
repeat_str -v s ab 3  # s="ababab"
```

### center

```bash
center [-v Var] [-l Len] [-p Padding_str] Str
```

居中显示字符串。
- `-v Var`表示将居中后的字符串赋值给变量，否则将输出居中后的字符串  
- `-l Len`表示居中后的字符串长度(字符数)，如果不指定该选项，则默认总长度为80  
- `-p Padding_str`表示使用字符串Padding_str填充在左右两边  

例如：
```bash
center -l 10 "hell"   # '   hell   '
center -l 10 "hello"  # '   hello  '

center -l 15 "hell" 
#=> "      hell     "
center -l 15 -p abc " hell " 
#=> "abcab hell abca"
center -l 15 -p abc " hihello " 
#=> "abc hihello abc"
```

### trim

```bash
trim [-l] [-r] [-v Var] [Target] String
# !     Default: trim leading and trailing whitespaces
# !     Target: trim specify char(s). If omit,
# !             default to trim whitespaces
# !    -l: only trim leading chars
# !    -r: only trim trailing chars
# !    -v VAR: assign result to shell variable VAR,
# !            rather than output it
```

修剪String字符串左边和右边的字符。
- `-l`选项表示修剪左边  
- `-r`选项表示修剪右边  
- `-v Var`表示将修剪后的字符串赋值给变量Var，否则将输出修剪后的字符串  
- `Target`表示要修剪左右两边的什么字符，未指定Target时，默认将修剪空白字符  

当未指定`-l`和`-r`时，默认同时修剪左右两边，等价于同时指定它们。

例如：
```bash
trim '  a b  '       # "a b"
trim -l '  a b  '    # "a b  "
trim -r '  a b  '    # "  a b"
trim -r -l '  a b  ' # "a b"

trim 'x' 'xa bx'         # "a b"
trim 'x' 'xxa bxx'       # "a b"
trim -l 'x' 'xxa bxx'    # "a bxx"
trim -r 'x' 'xxa bxx'    # "xxa b"
trim -r -l 'x' 'xxa bxx' # "a b"

trim -l 'xy' 'xyxya bxyxy' # "a bxyxy"
trim -r 'xy' 'xyxya bxyxy' # "xyxya b"
trim 'xy' 'xyxya bxyxy'    # "a b"
trim 'xy' 'a b'            # "a b"
trim -v var 'xy' 'xyxyab'   # var="ab"
```

### squash

```bash
squash [-v Var] [-s] [Target] str
```

压缩字符串str中指定的连续目标字符。
- `-v Var`表示将压缩后的字符串赋值给变量Var，否则压缩后的字符串将被输出  
- `-s`表示不先移除前缀连续和后缀连续目标字符后再压缩。不指定该选项时，将先移除前缀和后缀连续目标字符，然后再压缩  
- `Target`表示压缩字符串中的哪个连续字符，如果该选项超过一个字符，则只有第一个字符被当作目标字符  

例如：
```bash
squash  '  a  b  c  '        # "a b c"
squash -s '  a  b  c  '      # " a b c "
squash "," ',,,a,,b,,c,,'    # "a,b,c"
squash -s "," ',,,a,,b,,c,,' # ",a,b,c,"
squash -s ",-" ',,-a,,--b,,c,,' # ",-a,--b,c,"
```

### split

```bash
split -v Arr [Sep] String
```

根据指定分隔符Sep，将字符串String划分为多个部分后保存到数组Arr中。

当未指定分隔符Sep时，默认按照空格划分字符串。且在划分之前，会执行如下两个步骤：
- 移除String中前缀和后缀的连续分隔符  
- String中出现的连续分隔符总是先被压缩到单个分隔符  

例如：
```bash
split -v arr 'x' 'xxabcxdefxghixjklxx'
#=> arr=(abc def ghi jkl)
split -v arr1 ' abc  def  ghi  jkl  '
#=> arr1=(abc def ghi jkl)
```

### index和index_all

```bash
index [-v Var] [-r] Substr String
index_all [-v Arr] Substr String
```

`index`搜索字符串String中第一次出现子串Substr的索引位置，默认从左向右搜索。指定`-r`选项表示从右向左搜索。如果String中未搜索到Substr，则以-1表示索引值。指定`-v Var`可将搜索到的索引值(包括未搜索到时的-1索引值)赋值给变量Var，否则将输出。

`index_all`搜索字符串String中所有Substr出现的索引位置，默认将输出这些索引值，指定`-v Arr`表示将这些索引值保存到数组Arr。如果String中未搜索到Substr，则输出空或保存为空数组。

例如：

```bash
# 从左向右搜索第一次出现的子串
index 'ab' 'abcdab'      # 0
index 'ab' 'ABabcdab'    # 2
index 'a b' 'ABa bcdab'  # 2
index 'a b' 'ABabcdab'   # -1

# 从右向左搜索第一次出现的子串
index -r 'ab' 'abcd'     # 0
index -r 'ab' 'abcdab'   # 4
index -r 'a b' 'abcda b' # 4
index -r 'a b' 'abcdab'  # -1

# 搜索所有子串出现的索引位置
index_all 'ab' 'abcdab'    # `0 4' or '(0 4)'
index_all 'ab' 'abcdabab'  # `0 4 6' or '(0 4 6)'
index_all 'abx' 'def'      # '' or ()
```

### chars

```bash
chars [-v Arr] Str
```

将字符串每个字符保存到数组Arr，如果未指定`-v Arr`，则以`(x y z)`的字符串格式输出各字符。

例如：
```bash
chars 'abcd'  # (a b c d)
chars -v arr 'abcd'  # arr=(a b c d)
```

### str_slice

```bash
str_slice [-v Var] Str         # (1)
str_slice [-v Var] M..N Str    # (2)
str_slice [-v Var] N [Len] Str # (3)
```

获取字符串Str的切片(即子串)。指定`-v Var`选项时，表示将获取到的子串赋值给变量Var，否则将输出子串。

对于语法(1)，表示获取Str的所有字符，即Str的副本。

对于语法(2)，表示获取Str中指定范围的字符。支持的范围语法包括`M..N, ..N, M..`。M和N代表索引，它们可以是负数，表示从右向左的索引，-1表示倒数第一个字符，-2表示倒数第二个字符。但要注意，指定的范围是合法的，不允许M代表的索引位置在N代表的索引位置的右边。

对于语法(3)，表示从索引位置N处开始，获取长度为Len的子串。N可以为负数，表示从右向左计算负数索引位置。如果省略Len参数，表示获取从N开始的剩余所有字符。Len也可以为负数，此时它不表示长度，而是表示获取的终止索引位置，且从右向左计算负数索引位置。

例如：
```bash
test_str__="01234567890abcdefgh"
str_slice "${test_str}"       # "01234567890abcdefgh"

str_slice 1..3 "${test_str}"  # "123"
str_slice 7.. "${test_str}"   # "7890abcdefgh"
str_slice ..7 "${test_str}"   # "01234567"
str_slice 1..-7 "${test_str}" # "1234567890ab"
str_slice -7.. "${test_str}"  # "bcdefgh"
str_slice ..-7 "${test_str}"  # "01234567890ab"
str_slice -10..-7 "${test_str}"  # "90ab"

str_slice 7 "${test_str}"     # "7890abcdefgh"
str_slice 7 0 "${test_str}"   # ""
str_slice 7 2 "${test_str}"   # "78"
str_slice 7 -2 "${test_str}"  # "7890abcdef"
str_slice -7 "${test_str}"    # "bcdefgh"
str_slice -7 2 "${test_str}"  # "bc"
str_slice -7 -2 "${test_str}" # "bcdef"
```

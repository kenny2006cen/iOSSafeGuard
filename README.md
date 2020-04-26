# iOSSafeGuard
iOS-Safe-Guard,jailbreak

Mach-O,是Mach object的缩写
文件类型有11种：
<!--XNU内核源码查看-->

MH_OBJECT  目标文件(.o)
静态库文件( .a) 
MH_EXECUTE 可执行文件

MH_DYLB 动态库文件
.dylib
.fraomework

MH_DYLINKER 动态链接器
/usr/lib/dyli

MH_DSYM 二进制符号表
.dSYM/Contesnts/Resources/DWARF/xx(常用于分析app可执行文件的奔溃信息)

clang -o test2 test.c 
file test2
test:Mach-O （打印输出）
./test2 (执行)

lipo -info  查看文件架构信息
lipo test2 - thin armv64 -output "文件名"

Macho-o文件基本结构
Header
 (文件类型，目标架构类型等)
Load commands
    (描述文件在虚拟内存中的逻辑结构，布局)
    Segment command 1
    Segment command 2
Data
    _TEXT (函数代码)
    _DATA (全局变量)




otool:查看mach-o特定部分和段的内容
  otool -H
  otool -L
GUI工具
  MachOview


lldb

image lookup -t 类型 :查找某歌嘞多信息
image lookup -a 地址：根据地址查找在模块中的位置(崩溃中可以定位错误代码的文件名和所在行数)
image lookup -n 符号后者函数名：查找某个符号或者函数的位置；
image list 
  列出所加载的模块信息
image list -o -f 
  打印模块的偏移地址 全路径

br s -n test 方法断点

//内存断点

watchpoint set variable 变量 (内存数据发生改变时候触发)
watchpoint set varialble self->_age;//监听self.age; 然后bt指令，查看调用站

register read x0 (读取)
register write x0 0x11 (修改)

e -- self.sign =1; (执行变量修改等)


汇编
  ldr (内存中读取数据)



#pragma - 混合密码系统
对称加密 --不能很好的解决密钥配送问题
公私钥加密 -- 加解密速度比较慢 
混合密码系统 --将对称密码和公钥密码的优势相结合 (iOS底层班p167)

因为RSA加密速度太慢，所以内容选择用AES加密，KEY用RSA进行加密。

1.随机生成16位字符串 做为AES加密的KEY ，以保证每次加密相同内容的密文不一样。

2.客户端负责加密数据，只放公钥，用公钥对生成的KEY进行RSA加密。

3.重要的密钥放在后台，后台只负责解密，先用密钥解出KEY，再用key解密AES密文。


单向散列函数：根据任意长度的消息，计算出固定长度的散列值
    MD5:(128bit散列值,可以破解)
    SHA256: (防数据篡改)

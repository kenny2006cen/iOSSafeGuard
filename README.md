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

isa指针
    instance的isa指向class
    当调用对象方法时，通过instance的isa找到class,最后找到对象方法的实现进行调用
    class的isa指向meta-class
    当调用类方法时，通过class的isa找到meta-class,最后找到类方法的实现进行调用
    
    Cateogry的本质
    struct category_t {
    const char *name;//类名
    classref_t cls;  // 0
    struct method_list_t *instanceMethods; // 对象方法
    struct method_list_t *classMethods; // 类方法
    struct protocol_list_t *protocols; // 协议
    struct property_list_t *instanceProperties; // 属性
    // Fields below this point are not always present on disk.
    struct property_list_t *_classProperties;
    
    method_list_t *methodsForMeta(bool isMeta) {
    if (isMeta) return classMethods;
    else return instanceMethods;
    }
    
    property_list_t *propertiesForMeta(bool isMeta, struct header_info *hi);
    };
    
    源码基本可以看出我们平时使用categroy的方式，对象方法，类方法，协议，和属性都可以找到对应的存储方式。并且我们发现分类结构体中是不存在成员变量的，因此分类中是不允许添加成员变量的。分类中添加的属性并不会帮助我们自动生成成员变量，只会生成get set方法的声明，需要我们自己去实现。
    

    
    Category中，load方法调用顺序
      一般情况下：父类->子类->category
       本质是直接查找方法
    initialize方法调用顺序
       父类->Category->(没有category就是子类调用)
       initialize本质调用是objc_msgSend方法通过isa指针d调用方法，找到方法就会调用 
       
    OC对象的本质，结构体(通过 clang -rewrite-objc main.m -o main.cpp)
    NSObject对象本质: 
    struct NSObject_IMPL{
    Class isa;
    }


  p self.person1.isa (打印对象指针,KVO本质,派生子类实现观察者模式)
  (Class) $0=NOKVONotify_MJPerons

    block变量捕获机制
    变量类型                 捕获到block内部              访问方式
    局部变量：auto                    yes                 值传递
            static                   yes                 指针传递
                                                        
    全局变量： (类以外的变量)           NO                    直接访问

 block3中类型，可以通过class方法或者isa指针查看类型，都继承NSBlock类型
 __NSGlobalBlock__
__NSStackBlock__  (调用copy方法->__NSMallocBlock__)
__NSMallocBlock__

__block修饰auto变量，内部会包装成一个对象，这样就可以在内部修改变量的值

Runtime
struct objc_class{
Class isa;
Class superclass;
cache_t cache; //方法缓存
class_data_bits_t bits;//用于获取具体的类信息
}

struct class_rw_t{
method_list_t *methods;
property_list_t *properties;
const protocol_list_ *protocols;
}


objc_msgSend方法c底层三大阶段
消息发送（当前类，父类中查找）->动态方法解析->消息转发


runloop的基本作用
1.保持程序的持续运行；
2.处理app中的各种事件(比如触摸事件，定时器事件)
3.节省CPU资源，提高程序性能；该做事时做事，该休眠时休眠；

NSRunLoop * loop =[NSRunLoop currentRunLoop];
CRRunLoopRef *loop ;(开源)

runloop与线程的关系
1.每个线程对应一个Runloop对象；
2.runloop保存在一个全局的Dictionary里面，线程作为key,Runloop作为value
3.线程刚创建时没有runloop对象，runloop会在第一次获取它h时创建;


runloop的作用
1.线程保活
2.解决nstimer停止问题；
3.监控应用卡顿；
4.性能优化；


设计模式
MVC
        优点:View,Model可以重复利用；
        缺点：Controller的代码过于臃肿;
        
MVP(Model-View-presenter)


MVVM(Model-View-ViewModel)


性能优化
    卡顿解决的主要思路：尽可能减少CPU,GPU资源消耗；
    按照60FPS的刷帧率，每隔16ms就有一次vsync信号；(vsync信号到来，GPU还没处理完，就卡)
    
    CPU方面:
    1.尽量使用轻量级的对象，比如用不到事件处理的地方，可以考虑用calayer取代uiview;
    2.不要频繁的调用UIView的相关属性，比如frame,bounds,transform等属性，减少不必要的修改；
    3.尽量提前计算好布局，不要多次修改属性；
    4.autolayout会比直接设置frame消耗更多的cpu资源；
    5.图片size最好和UIImageView的size一致，避免缩放；
    6.控制线程的最大并发数量；
    7.耗时操作放到子线程；
    8.文本处理（尺寸计算，绘制);
    9.图片处理（解码，绘制）；
    
    GPU方面：
    1.尽量减少视图数量和层次
        2.GPU能处理的最大纹理尺寸是4096x4096，一旦超过这个尺寸，就会占用CPU资源进行处理，所以纹理尽量不要超过这个尺寸
    3.尽量避免段时间内大量图片的显示，尽可能将多张图片合成一张图片显示
    4.减少透明的视图（alpha<1），不透明的就设置opaque为yes
    5.尽量避免出现离屏渲染
            (openGL中，GPU有两种渲染方式)
            On-Screen rendering:当前屏幕渲染，当前用于显示的屏幕缓冲区进行渲染；
            Off-Screen rendering:离屏渲染，在当前屏幕缓冲区以外开辟一个缓冲区进行渲染操作；
            
            离屏渲染消耗性能的原因
            
            需要创建新的缓冲区
            离屏渲染的整个过程，需要多次切换上下文环境，先是从当前屏幕（On-Screen）切换到离屏（Off-Screen）；等到离屏渲染结束以后，将离屏缓冲区的渲染结果显示到屏幕上，又需要将上下文环境从离屏切换到当前屏幕
            哪些操作会触发离屏渲染？
            
            光栅化，layer.shouldRasterize = YES
            遮罩，layer.mask
            圆角，同时设置 layer.masksToBounds = YES、layer.cornerRadius大于0
            考虑通过 CoreGraphics 绘制裁剪圆角，或者叫美工提供圆角图片
            阴影，layer.shadowXXX，如果设置了 layer.shadowPath 就不会产生离屏渲染
            
            作者：全网iOS面试题总结
            链接：https://www.jianshu.com/p/02ab3ba0212e
            来源：简书
            著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。
    
    
   APP启动优化
    冷启动
    通过添加环境变了可以打印出app的启动时间分析(EditSchem->Run-Arguments)
    DYLD_PRINT_STATSTICS_TETAILS 设置为1
    /*启动时间在400ms以内是比较正常的*/
    冷启动大体分为三大阶段
    dyld加载可执行文件到内存，顺便加载所有依赖的动态库;
    runtime初始化,加载成objc定义的结构;
    main函数;
    
    优化阶段：
    1.dyld阶段;
      减少动态库，合并动态库；
      减少objc类，分类的数量，减少selector数量；
      减少C++虚函数数量；
      
      2.runtime阶段
         尽量用+initialize方法和dispatch_once取代所有的__attribute_((constrctor),C++静态构造器，objc的+load
         
      3.main函数阶段；
         在不影响用户体验的前提下，尽可能将一些操作延迟，不要都放在finishLaunching方法中；
         按需加载；
         UI实现尽量使用纯代码，减少xib等文件的使用（xib等文件需要转换为纯代码，耗费时间);
         减少资源文件大小;

    IPA安装包瘦身
    1.资源（图片，音频，视频等）无损压缩；
    去除没有用到的资源:LSUnusedResources;
    2.可执行文件瘦身
       编译器优化；
       使用AppCode检测未使用的代码,菜单栏->Code->Inspect Code
       LLVM插件检测重复代码，未使用代码

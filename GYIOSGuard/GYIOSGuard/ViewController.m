//
//  ViewController.m
//  GYIOSGuard
//
//  Created by jlc on 2020/4/9.
//  Copyright © 2020 jlc. All rights reserved.
//

#import "ViewController.h"
#import <os/lock.h>
//#import <pthread.h>
@interface ViewController ()

@property(nonatomic,strong)NSThread *thread;
@property(nonatomic,assign)BOOL isStop;
@property(nonatomic,strong)NSTimer *timer;

//@property(nonatomic,assign)OSSpinLock lock;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
}

-(void)startThread{
    
    self.thread =[[NSThread alloc]initWithBlock:^{
      
        //线程保活
        [[NSRunLoop currentRunLoop]addPort:[[NSPort alloc]init] forMode:NSDefaultRunLoopMode];
        
       // [[NSRunLoop currentRunLoop]run];//该方法无法停止
        
        while (!self.isStop) {
            [[NSRunLoop currentRunLoop]runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
            //这样就不会超时，一直做事情
        }
    }];
    
    [self.thread start];
}

-(void)stopThread{

  //  CFRunLoopStop(<#CFRunLoopRef rl#>)
}

-(void)runLoopTest{
    
    NSLog(@"111");
    //[self performSelector:@selector(test) withObject:nil afterDelay:0];
    //该方法底层用的是nstimer定时器,和runloop有关,因此    NSLog(@"2");后打印;
    //如果在子线程中调用，由于其本质是往runloop中添加定时器，而子线程默认没有启动runloop导致的
    

    NSLog(@"333");

}
-(void)test{
    NSLog(@"222");

}

-(void)gcdGroupTest{
    
    //线程组
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_queue_t queue = dispatch_queue_create("co", DISPATCH_QUEUE_CONCURRENT);
    
    
    dispatch_group_async(group, queue, ^{
        
    });
    
    
    dispatch_group_notify(group, queue, ^{
        
    });
    
    //线程安全问题，多线程访问同一资源
    /*
     使用线程同步技术，按预定的先后顺序进行运行
     常见的线程同步技术是：加锁
     lock->read->modify->write->unlock
     */
    //自旋锁,忙等，会一直占用cpu资源；目前不再安全安全，可能有优先级反转问题；
    //OSSPINLOCK;(需要加同一把锁)
    //
    
    //
   // os_unfair_lock_t;优先级反转问题解决,ios10才有,休眠状态等待。
    //pthread_mutex,互斥锁,等待锁的时候处于休眠状态
    //pthread_mutex,递归锁，允许同一线程对一把锁进行重复加锁
    //dispatch_semaphore;//信号量(串行队列也可以实现)
    //dispatch_semaphore 可以控制线程并发访问的最大数量
//    NSOperationQueue *queue2;
//    queue2.maxConcurrentOperationCount=1;
    //设置最大并发量为1，可实现线程同步
    
    //NSLock (对pthread_mutex普通锁的封装)
    //NSRecursiveLock(对pthread_mutex递归锁的封装)
    //NSCondition
    //NSConditionLock
    
    //@synchronized(mutex,递归锁的封装)
    //性能高到低：os_unfair_lock>OSSpinLock>dispatch_semaphore>pthread_mutex>...>synchronized
    
    //读写安全，多读单写
    //pthread_rwlock
    dispatch_barrier_async(queue, ^{
        
    });
    
    __weak typeof(self)wealSelf = self;
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
        
//        [wealSelf test];
    }];
    
    //NSProxy是专门为消息转发而设计的抽象类
    //nil：空指针，不指向任何位置的指针。
    //id 声明的对象具有运行时的特性，即可以指向任意类型的Objcetive-C的对象
    //NULL：指针存储的地址是一个空地址。
}

- (void)dealloc
{
    [self.timer invalidate];
}

//算法相关
//1.字符串反转
-(void)charReverse{
    
    NSString * string = @"hello,world";
    
    NSMutableString * reverString =[NSMutableString stringWithString:string];
    
    for (NSInteger i=0; i<(string.length+1)/2; i++) {
        
        [reverString replaceCharactersInRange:NSMakeRange(i, 1) withString:[string substringWithRange:NSMakeRange(string.length-i-1, 1)]];//string最后一个放最前面
        
        [reverString replaceCharactersInRange:NSMakeRange(string.length-i-1, 1) withString:[string substringWithRange:NSMakeRange(i, 1)]];//string第一个放最后面
        
        
        
        
         
        
    }
    
}


//链表反转
/**  定义一个链表  */
struct Node {
    
    NSInteger data;
    
    struct Node * next;
};


+ (void)listReverse
{
    struct Node * p = [self constructList];
    
    [self printList:p];
    
    //反转后的链表头部
    struct Node * newH = NULL;
    //头插法
    while (p != NULL) {
        
        //记录下一个结点
        struct Node * temp = p->next;
        //当前结点的next指向新链表的头部
        p->next = newH;
        //更改新链表头部为当前结点
        newH = p;
        //移动p到下一个结点
        p = temp;
    }
    
    [self printList:newH];
}
/**
 打印链表
 
 @param head 给定链表
 */
+ (void)printList:(struct Node *)head
{
    struct Node * temp = head;
    
    printf("list is : ");
    
    while (temp != NULL) {
        
        printf("%zd ",temp->data);
        
        temp = temp->next;
    }
    
    printf("\n");
}


/**  构造链表  */
+ (struct Node *)constructList
{
    //头结点
    struct Node *head = NULL;
    //尾结点
    struct Node *cur = NULL;
    
    for (NSInteger i = 0; i < 10; i++) {
        
        struct Node *node = malloc(sizeof(struct Node));
        
        node->data = i;
        
        //头结点为空，新结点即为头结点
        if (head == NULL) {
            
            head = node;
            
        }else{
            //当前结点的next为尾结点
            cur->next = node;
        }
        
        //设置当前结点为新结点
        cur = node;
    }
    
    return head;
}

#pragma mark - 直接排序
-(void)sortingForInsertWithArray:(NSMutableArray *)array{
    for (int i = 1; i<=array.count-1; i++) {
        
        //如果前面的比后面的大,
        if (array[i-1] > array[i]) {
            int j = i-1;//
            id temp = array[i];//后面那个先保存
            array[i] = array[i-1];//前面那个->交换到后面
           
            while (j>=0&&temp<array[j]) {
                array[j+1] = array[j];
                j--;
            }
            array[j+1] = temp;
        }
    }
}


@end

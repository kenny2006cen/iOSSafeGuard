//
//  AppDelegate.m
//  GYIOSGuard
//
//  Created by jlc on 2020/4/9.
//  Copyright © 2020 jlc. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
  //  [self testGCD];
    NSString *firstUserName = @"nick"; NSString *secondUserName = @"nick";
    if (firstUserName == secondUserName) {
        NSLog(@"areEqual"); }
    else { NSLog(@"areNotEqual");
    }
    
    //[ViewController listReverse];
    
    return YES;
}


-(void)testGCD{
    
    
    NSLog(@"111");
    
    //串行，并行，同步，异步
    
    //同步，异步只影响是否开启线程
    //
    dispatch_queue_t queue = dispatch_queue_create("queue", DISPATCH_QUEUE_SERIAL);
    //DISPATCH_QUEUE_CONCURRENT
    
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    
    //如果传入的是主队列,将不会开启线程
    
    //    dispatch_async(queue
    //                   , ^{
    //
    //                   });
    
    //同步，当前线程，只能串行执行
    dispatch_sync(mainQueue, ^{
        NSLog(@"222");
        
    });
    NSLog(@"333");
}

/*
 GCD实现多读单写
 #import "WHObject.h"
 
 @interface WHObject()
 
 @property (nonatomic, strong) dispatch_queue_t dictQueue;//并发队列
 @property (nonatomic, strong) NSMutableDictionary *dict;//可变字典
 
 @end
 
 @implementation WHObject
 
 - (instancetype)init {
 if(self = [super init]) {
 _dictQueue = dispatch_queue_create("com.huangwenhong.queue", DISPATCH_QUEUE_CONCURRENT);
 _dict = [NSMutableDictionary dictionary];
 }
 return self;
 }
 
 - (void)huangwenhongmethod {
 self.target = [NSObject new];
 }
 
 - (id)valueForKey:(NSString *)key {
 id __block obj;
 dispatch_sync(_dictQueue, ^{//因为有数据 return，所以这里是同步调用
 obj = [self.dict valueForKey:key];
 });
 return obj;
 }
 
 - (void)setObject:(id)obj forKey:(id<NSCopying>)key {
 //重点：dispatch_barrier_async()，异步栅栏调用；
 //只有提交到并行队列才有意义
 dispatch_barrier_async(_dictQueue, ^{
 [self.dict setObject:obj forKey:key];
 });
 }
 
 
 
 
 @end
 

 */

#pragma mark - UISceneSession lifecycle




@end

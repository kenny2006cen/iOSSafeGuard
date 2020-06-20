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
    
    [ViewController listReverse];
    
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



#pragma mark - UISceneSession lifecycle




@end

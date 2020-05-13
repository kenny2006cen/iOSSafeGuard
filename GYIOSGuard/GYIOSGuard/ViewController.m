//
//  ViewController.m
//  GYIOSGuard
//
//  Created by jlc on 2020/4/9.
//  Copyright © 2020 jlc. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property(nonatomic,strong)NSThread *thread;
@property(nonatomic,assign)BOOL isStop;
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

@end

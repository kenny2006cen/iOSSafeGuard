//
//  main.m
//  GYIOSGuard
//
//  Created by jlc on 2020/4/9.
//  Copyright © 2020 jlc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "GYIOSGuardManager.h"

int main(int argc, char * argv[]) {
    
    NSString * appDelegateClassName;
    
    @autoreleasepool {
        // Setup code that might create autoreleased objects goes here.
        appDelegateClassName = NSStringFromClass([AppDelegate class]);
    }
    
  //  [GYIOSGuardManager  runAntiDebug];
    
    return UIApplicationMain(argc, argv, nil, appDelegateClassName);

}

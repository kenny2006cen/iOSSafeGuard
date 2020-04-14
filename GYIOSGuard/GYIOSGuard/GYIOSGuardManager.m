//
//  GYIOSGuardManager.m
//  GYIOSGuard
//
//  Created by jlc on 2020/4/9.
//  Copyright © 2020 jlc. All rights reserved.
//

#import "GYIOSGuardManager.h"

@implementation GYIOSGuardManager

+ (BOOL)isJailBreak {
    
    BOOL isBreak = NO;
    
    NSString *cydiaPath = @"/Applications/Cydia.app";
    NSString *aptPath = @"/private/var/lib/apt/";
    NSString *applications = @"/User/Applications/";
    NSString *Mobile = @"/Library/MobileSubstrate/MobileSubstrate.dylib";
    NSString *bash = @"/bin/bash";
    NSString *sshd =@"/usr/sbin/sshd";
    NSString *sd = @"/etc/apt";
    
    NSArray *pathArr =@[cydiaPath,aptPath,applications,Mobile,bash,sshd,sd];
    //查看文件目录
    for (NSString *path in pathArr) {
        if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
            isBreak = YES;
            break;
        }
    }
    
    return isBreak;
    
}

-(void)runAntiDebug{
    
}

@end

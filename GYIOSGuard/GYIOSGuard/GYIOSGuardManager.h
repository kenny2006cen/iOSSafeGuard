//
//  GYIOSGuardManager.h
//  GYIOSGuard
//
//  Created by jlc on 2020/4/9.
//  Copyright © 2020 jlc. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GYIOSGuardManager : NSObject

//越狱检测
+(BOOL)isJailBreak;

//反调试,注意,appstore不能使用此方法，因为内部使用dlopen
+(void)runAntiDebug;
//反注入
+(void)runAntiInjection;

//全局拦截系统异常，(Bugly此时将会失效)
+(void)checkAppExceptionHandler;

@end

NS_ASSUME_NONNULL_END

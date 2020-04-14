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

//+(BOOL)isJailBreak;
//注意,appstore不能使用此方法，因为内部使用dlopen
+(void)runAntiDebug;

@end

NS_ASSUME_NONNULL_END

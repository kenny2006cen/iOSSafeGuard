//
//  GYIOSGuardManager.m
//  GYIOSGuard
//
//  Created by jlc on 2020/4/9.
//  Copyright © 2020 jlc. All rights reserved.
//

#import "GYIOSGuardManager.h"
#import <dlfcn.h>
#import <sys/types.h>
#import  <sys/sysctl.h>
#include <unistd.h>
#include <sys/ioctl.h>

#import <Foundation/Foundation.h>

typedef int  (*ptrace_ptr_t)(int _request,pid_t pid,caddr_t _addr,int _data);
#ifndef PT_DENY_ATTACH
#define PT_DENY_ATTACH 31
#endif

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

+(void)runAntiDebug{
    
    if (isDebuggerPresent()) {
        exit(0);
    }
    
    antiDebug_01();
    antiDebug_02();
    antiDebug_03();
    check_svc_integrity();
    AntiDebug_ioctl();
    AntiDebug_isatty();
    
}

//sysctl 反调试,可以定时执行以上代码，当检测到程序正在被调试，可以调用exit(0)来让程序奔溃或者做其他的操作
BOOL isDebuggerPresent(){
    
int name[4];//指定查询信息的数组
   struct kinfo_proc info;//查询的返回结果
   size_t info_size = sizeof(info);
   info.kp_proc.p_flag = 0;
   
   name[0] = CTL_KERN;
   name[1] = KERN_PROC;
   name[2] = KERN_PROC_PID;
   name[3] = getpid();
   if (sysctl(name, 4, &info, &info_size, NULL, 0) == -1) {
       NSLog(@"sysctl error ...");
       return NO;
   }
   return ((info.kp_proc.p_flag & P_TRACED) != 0);

}


static __attribute__((always_inline)) void antiDebug_01() {
    
    // ptrace(PT_DENY_ATTACH,0,0,0); //系统函数并没有暴露出此方法所以不能直接通过此方式调用

         void *handle = dlopen(0, RTLD_NOW|RTLD_GLOBAL);
           ptrace_ptr_t ptrace_ptr = (ptrace_ptr_t)dlsym(handle, "ptrace");
           ptrace_ptr(PT_DENY_ATTACH,0,0,0);

}

//syscall可以通过软中断实现从用户态切换到系统内核态的转换，同时可以通过arm 汇编实现以上功能。通过asm volatile内联汇编，实际上也是调用了ptrace。

static __attribute__((always_inline)) void antiDebug_02(){
    
    #ifdef __arm__
            asm volatile(
                         "mov r0,#31\n"
                         "mov r1,#0\n"
                         "mov r2,#0\n"
                         "mov r12,#26\n"
                         "svc #80\n"

                         );
    #endif
    #ifdef __arm64__
            asm volatile(
                         "mov x0,#26\n"
                         "mov x1,#31\n"
                         "mov x2,#0\n"
                         "mov x3,#0\n"
                         "mov x16,#0\n"
                         "svc #128\n"
                         );
    #endif
    
}


static __attribute__((always_inline)) void antiDebug_03() {
#ifdef __arm64__
    __asm__("mov X0, #26\n"
            "mov X1, #31\n"
            "mov X2, #0\n"
            "mov X3, #0\n"
            "mov X4, #0\n"
            "mov w16, #0\n"
            "svc #0x80");
#endif
}

//svc 完整性检测
static __attribute__((always_inline)) void check_svc_integrity() {
    int pid;
    static jmp_buf protectionJMP;
#ifdef __arm64__
    __asm__("mov x0, #0\n"
            "mov w16, #20\n"
            "svc #0x80\n"
            "cmp x0, #0\n"
            "b.ne #24\n"
            
            "mov x1, #0\n"
            "mov sp, x1\n"
            "mov x29, x1\n"
            "mov x30, x1\n"
            "ret\n"
            
            "mov %[result], x0\n"
            : [result] "=r" (pid)
            :
            :
            );
    
    if(pid == 0) {
        longjmp(protectionJMP, 1);
    }
#endif
}

//使用 ioctl 检测
static __attribute__((always_inline))  void AntiDebug_ioctl() {
    
  if (!ioctl(1, TIOCGWINSZ)) {
    exit(1);
  }
}

//使用 isatty 检测
void AntiDebug_isatty() {
  if (isatty(1)) {
    exit(1);
  }
}

@end

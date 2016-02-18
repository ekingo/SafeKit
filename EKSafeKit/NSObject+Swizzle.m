//
//  NSObject+swizzle.m
//  SafeKitExample
//
//  Created by zhangyu on 14-3-13.
//  Copyright (c) 2014年 zhangyu. All rights reserved.
//

#import "NSObject+Swizzle.h"
#import <objc/runtime.h>

#define EK_TRY_BODY(__target) \
@try {\
{__target}\
}\
@catch (NSException *exception) {\
NSLog(@"Exception:%@",[exception callStackSymbols]);\
}\
@finally {\
\
}

void SFLog(const char* file, const char* func, int line, NSString* fmt, ...)
{
    va_list args; va_start(args, fmt);
    NSLog(@"file:%s|func:%s|line:%d|args:%@", file, func, line, [[NSString alloc] initWithFormat:fmt arguments:args]);
    va_end(args);
}

@implementation NSObject(Swizzle)

+ (void)swizzleClassMethod:(SEL)origSelector withMethod:(SEL)newSelector{
    Class class = [self class];
    
    Method originalMethod = class_getClassMethod(class, origSelector);
    Method swizzledMethod = class_getClassMethod(class, newSelector);
    
    EK_TRY_BODY(
    Class metacls = objc_getMetaClass(NSStringFromClass(class).UTF8String);
    if (class_addMethod(metacls,
                        origSelector,
                        method_getImplementation(swizzledMethod),
                        method_getTypeEncoding(swizzledMethod)) ) {
        /* swizzing super class method, added if not exist */
        class_replaceMethod(metacls,
                            newSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
        
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
                )
}

- (void)swizzleInstanceMethod:(SEL)origSelector withMethod:(SEL)newSelector{
    Class class = [self class];
    
    Method originalMethod = class_getInstanceMethod(class, origSelector);
    Method swizzledMethod = class_getInstanceMethod(class, newSelector);
    
    EK_TRY_BODY(
    if (class_addMethod(class,
                        origSelector,
                        method_getImplementation(swizzledMethod),
                        method_getTypeEncoding(swizzledMethod)) ) {
        /*swizzing super class instance method, added if not exist */
        class_replaceMethod(class,
                            newSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
        
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
                )
}

@end

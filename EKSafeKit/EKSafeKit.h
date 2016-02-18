//
//  EKSafeKit.h
//  CallWatch
//
//  Created by kingo on 2/3/16.
//  Copyright © 2016 xtc. All rights reserved.
//

#ifndef EKSafeKit_h
#define EKSafeKit_h

#define kEnableSafeKit  1

extern void SFLog(const char* file, const char* func, int line, NSString* fmt, ...);

#define SFAssert(condition, ...) \
if (!(condition)){ SFLog(__FILE__, __FUNCTION__, __LINE__, __VA_ARGS__);} \
NSAssert(condition, @"%@", __VA_ARGS__);

/*!
 *  @author kingo, 16-02-03 15:02:07
 *
 *  @brief 处理一些由于代码不规范导致的程序闪退，比如NSArray中地址越界
 */


#endif /* EKSafeKit_h */

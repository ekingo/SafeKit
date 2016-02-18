//  NSObject+Swizzle.h
//  CallWatch
//
//  Created by kingo on 2/3/16.
//  Copyright © 2016 xtc. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 * This category adds methods to the NSObject.
 */
@interface NSObject(Swizzle)

/*!
 *  @author kingo, 16-02-03 15:02:51
 *
 *  @brief swizzle 类方法
 *
 *  @param origSelector 旧方法
 *  @param newSelector  新方法
 */
+ (void)swizzleClassMethod:(SEL)origSelector withMethod:(SEL)newSelector;
/*!
 *  @author kingo, 16-02-03 15:02:10
 *
 *  @brief swizzle实例方法
 *
 *  @param origSelector 旧方法
 *  @param newSelector  新方法
 */
- (void)swizzleInstanceMethod:(SEL)origSelector withMethod:(SEL)newSelector;

@end

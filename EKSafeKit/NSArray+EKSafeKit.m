//
//  NSArray+EKSafeKit.m
//  CallWatch
//
//  Created by kingo on 2/3/16.
//  Copyright © 2016 xtc. All rights reserved.
//

#import "NSArray+EKSafeKit.h"
#import "NSObject+Swizzle.h"
#import "EKSafeKit.h"

@implementation NSArray (EKSafeKit)

+ (instancetype)safeArrayWithObject:(id)anObject
{
    if (anObject) {
        return [self safeArrayWithObject:anObject];
    }
    NSLog(@"NSArray invalid args safeArrayWithObject:[%@]", anObject);
    return nil;
}

-(id)safeObjectAtIndex:(NSUInteger)index{
    if (index >= [self count]) {
        NSLog(@"EKException:Object out of Index");
        return nil;
    }
    return [self safeObjectAtIndex:index];
}

/* __NSArray0 没有元素，也不可以变 */
- (id)safeObjectAtIndex0:(NSUInteger)index {
    return nil;
}

+ (void)load{
#if kEnableSafeKit
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSLog(@"class name:%@",NSStringFromClass([self class]));
        //[self swizzleMethod:@selector(safeObjectAtIndex:) tarClass:@"__NSArrayI" tarSel:@selector(objectAtIndex:)];
        
        /* 类方法不用在NSMutableArray里再swizzle一次 */
        [NSArray swizzleClassMethod:@selector(arrayWithObject:) withMethod:@selector(safeArrayWithObject:)];
        
        /* 数组有内容obj类型才是__NSArrayI */
        NSArray* obj = [[NSArray alloc] initWithObjects:@0, nil];
        NSLog(@"class name:%@",[obj class]);
        [obj swizzleInstanceMethod:@selector(objectAtIndex:) withMethod:@selector(safeObjectAtIndex:)];
        
        /* 没内容类型是__NSArray0 */
        //obj = [[NSArray alloc] init];
        NSLog(@"class name:%@",[obj class]);
        [NSClassFromString(@"__NSArray0") swizzleInstanceMethod:@selector(objectAtIndex:) withMethod:@selector(safeObjectAtIndex0:)];
    });
#endif
}

@end


@implementation NSMutableArray(EKSafeKit)
+ (void)load
{
#if kEnableSafeKit
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSMutableArray* obj = [[NSMutableArray alloc] init];
        //对象方法 __NSArrayM 和 __NSArrayI 都有实现，都要swizz
        [obj swizzleInstanceMethod:@selector(objectAtIndex:) withMethod:@selector(safeObjectAtIndex:)];
        
        [obj swizzleInstanceMethod:@selector(addObject:) withMethod:@selector(safeAddObject:)];
        [obj swizzleInstanceMethod:@selector(insertObject:atIndex:) withMethod:@selector(safeInsertObject:atIndex:)];
        [obj swizzleInstanceMethod:@selector(removeObjectAtIndex:) withMethod:@selector(safeRemoveObjectAtIndex:)];
        [obj swizzleInstanceMethod:@selector(replaceObjectAtIndex:withObject:) withMethod:@selector(safeReplaceObjectAtIndex:withObject:)];
        [obj swizzleInstanceMethod:@selector(removeObjectsInRange:) withMethod:@selector(safeRemoveObjectsInRange:)];
    });
#endif
}
- (void)safeAddObject:(id)anObject {
    if (anObject) {
        [self safeAddObject:anObject];
    } else {
        SFAssert(NO, @"NSMutableArray invalid args safeAddObject:[%@]", anObject);
    }
}
- (id)safeObjectAtIndex:(NSUInteger)index {
    if (index < self.count) {
        return [self safeObjectAtIndex:index];
    }
    return nil;
}
- (void)safeInsertObject:(id)anObject atIndex:(NSUInteger)index {
    if (anObject && index <= self.count) {
        [self safeInsertObject:anObject atIndex:index];
    } else {
        if (!anObject) {
            SFAssert(NO, @"NSMutableArray invalid args safeInsertObject:[%@] atIndex:[%@]", anObject, @(index));
        }
        if (index > self.count) {
            SFAssert(NO, @"NSMutableArray safeInsertObject[%@] atIndex:[%@] out of bound:[%@]", anObject, @(index), @(self.count));
        }
    }
}

- (void)safeRemoveObjectAtIndex:(NSUInteger)index {
    if (index < self.count) {
        [self safeRemoveObjectAtIndex:index];
    } else {
        SFAssert(NO, @"NSMutableArray safeRemoveObjectAtIndex:[%@] out of bound:[%@]", @(index), @(self.count));
    }
}


- (void)safeReplaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject {
    if (index < self.count && anObject) {
        [self safeReplaceObjectAtIndex:index withObject:anObject];
    } else {
        if (!anObject) {
            SFAssert(NO, @"NSMutableArray invalid args safeReplaceObjectAtIndex:[%@] withObject:[%@]", @(index), anObject);
        }
        if (index >= self.count) {
            SFAssert(NO, @"NSMutableArray safeReplaceObjectAtIndex:[%@] withObject:[%@] out of bound:[%@]", @(index), anObject, @(self.count));
        }
    }
}

- (void)safeRemoveObjectsInRange:(NSRange)range {
    if (range.location < self.count && range.location + range.length <= self.count) {
        [self safeRemoveObjectsInRange:range];
    }else {
        SFAssert(NO, @"NSMutableArray invalid args safeRemoveObjectsInRange:[%@]", NSStringFromRange(range));
    }
}

@end

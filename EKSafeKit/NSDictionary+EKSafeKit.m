//
//  NSDictionary+EKSafeKit.m
//  CallWatch
//
//  Created by kingo on 2/3/16.
//  Copyright © 2016 xtc. All rights reserved.
//

#import "NSDictionary+EKSafeKit.h"
#import "EKSafeKit.h"
#import "NSObject+Swizzle.h"

@implementation NSDictionary (EKSafeKit)

+ (void)load
{
#if kEnableSafeKit
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        /* 类方法 */
        [NSDictionary swizzleClassMethod:@selector(dictionaryWithObject:forKey:) withMethod:@selector(safeDictionaryWithObject:forKey:)];
        
        /* 数组有内容obj类型才是__NSDictionaryI，没内容类型是__NSDictionary0 */
        NSDictionary* obj = [NSDictionary dictionaryWithObjectsAndKeys:@0,@0,nil];
        [obj swizzleInstanceMethod:@selector(objectForKey:) withMethod:@selector(safeObjectForKey:)];
    });
#endif
}
+ (instancetype)safeDictionaryWithObject:(id)object forKey:(id)key
{
    if (object && key) {
        return [self safeDictionaryWithObject:object forKey:key];
    }
    SFAssert(NO, @"NSDictionary invalid args safeDictionaryWithObject:[%@] forKey:[%@]", object, key);
    return nil;
}
- (id)safeObjectForKey:(id)aKey
{
    if (aKey){
        return [self safeObjectForKey:aKey];
    }
    return nil;
}

@end

@implementation NSMutableDictionary (EKSafeKit)
+ (void)load
{
#if kEnableSafeKit
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSMutableDictionary* obj = [[NSMutableDictionary alloc] init];
        [obj swizzleInstanceMethod:@selector(objectForKey:) withMethod:@selector(safeObjectForKey:)];
        [obj swizzleInstanceMethod:@selector(setObject:forKey:) withMethod:@selector(safeSetObject:forKey:)];
        [obj swizzleInstanceMethod:@selector(removeObjectForKey:) withMethod:@selector(safeRemoveObjectForKey:)];
    });
#endif
}

- (id)safeObjectForKey:(id)aKey
{
    if (aKey){
        return [self safeObjectForKey:aKey];
    }else {
        //SFAssert(NO,@"NSMutableDictionary invalid args safeObjectForKey:[%@]",aKey);
    }
    return nil;
}

- (void)safeSetObject:(id)anObject forKey:(id)aKey {
    if (anObject && aKey) {
        [self safeSetObject:anObject forKey:aKey];
    } else {
        SFAssert(NO, @"NSMutableDictionary invalid args safeSetObject:[%@] forKey:[%@]", anObject, aKey);
    }
}

- (void)safeRemoveObjectForKey:(id)aKey {
    if (aKey) {
        [self safeRemoveObjectForKey:aKey];
    } else {
        SFAssert(NO, @"NSMutableDictionary invalid args safeRemoveObjectForKey:[%@]", aKey);
    }
}

@end
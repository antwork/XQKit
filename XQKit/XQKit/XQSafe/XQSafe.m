//
//  XQSafe.m
//  Lunkr
//
//  Created by Bill on 16/5/27.
//  Copyright © 2016年 qxu. All rights reserved.
//

#import "XQSafe.h"

@implementation NSObject (XQSafe)

- (id)safeObjectForKey:(NSString *)key {
    return nil;
}

@end


@implementation NSDictionary (XQSafe)

- (NSDictionary *)safeRemoveNull {
    NSMutableDictionary *opDict = [NSMutableDictionary dictionaryWithDictionary:self];
    
    NSDictionary *dict = (NSDictionary *)[opDict safeRemoveNull];
    
    return dict;
}

- (id)safeObjectForKey:(NSString *)key {
    if (!key || [NSNull null] == (NSNull *)key) {
        return nil;
    }
    return self[key];
}

@end

@implementation NSMutableDictionary (XQSafe)

- (NSMutableDictionary *)safeRemoveNull {
    NSMutableDictionary *results = [NSMutableDictionary dictionary];
    
    for (NSString *key in self.allKeys) {
        if ((NSNull *)key == [NSNull null]) {
            continue;
        }
        
        NSNull *value = [self objectForKey:key];
        
        if (value != [NSNull null]) {
            id oneItem = value;
            if ([value isKindOfClass:[NSArray class]]) {
                oneItem = [(NSArray *)value safeRemoveNull];
            } else if ([value isKindOfClass:[NSDictionary class]]) {
                oneItem = [(NSDictionary *)value safeRemoveNull];
            }
            if (oneItem) {
                [results setObject:oneItem forKey:key];
            }
        }
    }
    
    return results;
}

- (void)safeSetObject:(id)anObject forKey:(NSString *)aKey {
    [self safeSetObject:anObject forKey:aKey nilToBlank:NO];
}

- (void)safeSetObject:(id)object forKey:(NSString *)key nilToBlank:(BOOL)nilToBlank {
    if (key == nil || (object == nil && !nilToBlank)) {
        return;
    }
    
    if (object) {
        [self setObject:object forKey:key];
    } else if (nilToBlank) {
        [self setObject:@"" forKey:key];
    }
}

@end

@implementation NSMutableArray (XQSafe)

- (NSMutableArray *)safeRemoveNull {
    NSMutableArray *results = [NSMutableArray array];
    for (NSNull *value in self) {
        if (value != [NSNull null]) {
            id oneItem = value;
            if ([value isKindOfClass:[NSArray class]]) {
                oneItem = [(NSArray *)value safeRemoveNull];
            } else if ([value isKindOfClass:[NSDictionary class]]) {
                oneItem = [(NSDictionary *)value safeRemoveNull];
            }
            if (oneItem) {
                [results addObject:oneItem];
            }
        }
    }
    
    return results;
}

@end

@implementation NSArray (XQSafe)

- (NSArray *)safeRemoveNull {
    NSMutableArray *results = [NSMutableArray arrayWithArray:self];
    return [results safeRemoveNull];
}

@end

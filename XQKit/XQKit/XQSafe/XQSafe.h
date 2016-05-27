//
//  XQSafe.h
//  Lunkr
//
//  Created by Bill on 16/5/27.
//  Copyright © 2016年 qxu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSObject (XQSafe)

- (id)safeObjectForKey:(NSString *)key;

@end

@interface NSDictionary (XQSafe)

- (NSDictionary *)safeRemoveNull;

- (id)safeObjectForKey:(NSString *)key;

@end


@interface NSMutableDictionary (XQSafe)

- (NSMutableDictionary *)safeRemoveNull;

- (void)safeSetObject:(id)anObject forKey:(NSString *)aKey;

- (void)safeSetObject:(id)anObject forKey:(NSString *)key nilToBlank:(BOOL)nilToBlank;

@end

@interface NSMutableArray (XQSafe)

- (NSMutableArray *)safeRemoveNull;


@end


@interface NSArray (XQSafe)

- (NSArray *)safeRemoveNull;

@end


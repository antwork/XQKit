//
//  XQKVOArray.h
//  XQKVOArrayDemo
//
//  Created by Bill on 16/5/22.
//  Copyright © 2016年 XQ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^XQKVOBlock)(NSKeyValueChange change, NSIndexSet *indexes, NSArray *newValues, NSArray *oldValues, NSArray *allObjects);

@interface XQKVOMutableArray : NSObject

@property (copy, nonatomic) XQKVOBlock changeBlock;

- (instancetype)initWithChangeBlock:(XQKVOBlock)block;

- (NSInteger)count;

- (id)objectAtIndex:(NSInteger)index;

- (id)firstObject;

- (id)lastObject;

- (BOOL)containsObject:(id)obj;

- (NSInteger)indexOfObject:(id)obj;

- (NSArray *)allItems;

- (NSMutableArray *)allItemsMutable;

- (void)addObject:(id)anObject;

- (void)addObjectsFromArray:(NSArray *)otherArray;

- (void)insertObject:(id)anObject atIndex:(NSUInteger)index;

- (void)insertObjects:(NSArray *)objects atIndexes:(NSIndexSet *)indexes;

- (void)removeObject:(id)object;

- (void)removeLastObject;

- (void)removeObjectAtIndex:(NSUInteger)index;

- (void)removeAllObjects;

- (void)resetByArray:(NSArray *)array;

- (void)replaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject;

- (void)switchObjectAtIndex:(NSUInteger)index1 withObjectAtIndex:(NSUInteger)index2;

- (void)replaceObjectsAtIndexes:(NSIndexSet *)indexes withObjects:(NSArray *)objects;

@end

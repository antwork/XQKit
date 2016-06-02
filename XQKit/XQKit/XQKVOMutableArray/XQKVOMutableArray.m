//
//  XQKVOArray.m
//  XQKVOArrayDemo
//
//  Created by Bill on 16/5/22.
//  Copyright © 2016年 XQ. All rights reserved.
//

#import "XQKVOMutableArray.h"

@interface XQKVContainer : NSObject

@property (strong, nonatomic) NSMutableArray *backendArray;

@end

@implementation XQKVContainer

- (instancetype)init {
    if (self = [super init]) {
        _backendArray = [NSMutableArray array];
    }
    
    return self;
}

- (NSArray *)allObjects {
    return self.backendArray;
}

- (NSUInteger)countOfBackendArray {
    return [self.backendArray count];
}

- (id)objectAtIndex:(NSUInteger)index {
    id result = nil;
    
    if (index < [self countOfBackendArray]) {
        result = [self objectAtIndex:index];
    }
    return [self.backendArray objectAtIndex:index];
}

- (NSArray *)backendArrayAtIndexes:(NSIndexSet *)indexes {
    return [self.backendArray objectsAtIndexes:indexes];
}

- (NSUInteger)indexOfObject:(id)obj {
    return [self.backendArray indexOfObject:obj];
}

// 添加
- (void)insertObject:(id)object inBackendArrayAtIndex:(NSUInteger)index {
    [self.backendArray insertObject:object atIndex:index];
}

- (void)insertBackendArray:(NSArray *)array atIndexes:(NSIndexSet *)indexes {
    [self.backendArray insertObjects:array atIndexes:indexes];
}

// 移除

- (void)removeObjectFromBackendArrayAtIndex:(NSUInteger)index {
    [self.backendArray removeObjectAtIndex:index];
}

- (void)removeBackendArrayAtIndexes:(NSIndexSet *)indexes {
    [self.backendArray removeObjectsAtIndexes:indexes];
}

// 替换

- (void)replaceObjectInBackendArrayAtIndex:(NSUInteger)index withObject:(id)object {
    [self.backendArray replaceObjectAtIndex:index withObject:object];
}

- (void)replaceBackendArrayAtIndexes:(NSIndexSet *)indexes withBackendArray:(NSArray *)array {
    [self.backendArray replaceObjectsAtIndexes:indexes withObjects:array];
}


@end

@interface XQKVOMutableArray() {
    dispatch_semaphore_t _lock;
}

@property (strong, nonatomic) XQKVContainer *containerXQ;

@end


@implementation XQKVOMutableArray

- (void)dealloc {
    [self.containerXQ removeObserver:self forKeyPath:@"backendArray"];
    
    self.containerXQ = nil;
}

- (instancetype)initWithChangeBlock:(XQKVOBlock)block {
    if (self = [super init]) {
        [self setup];
        _changeBlock = block;
    }
    
    return self;
}

- (instancetype)init {
    return [self initWithChangeBlock:nil];
}

#pragma mark - APIs

- (NSInteger)count {
    dispatch_semaphore_wait(_lock, DISPATCH_TIME_FOREVER);
    NSInteger count = [self.containerXQ countOfBackendArray];
    dispatch_semaphore_signal(_lock);
    return count;
}

- (void)addObject:(id)anObject {
    dispatch_semaphore_wait(_lock, DISPATCH_TIME_FOREVER);
    NSInteger count = [self.containerXQ countOfBackendArray];
    if (count < 0) {
        count = 0;
    }
    [self.containerXQ insertObject:anObject inBackendArrayAtIndex:count];
    dispatch_semaphore_signal(_lock);
}

- (id)objectAtIndex:(NSInteger)index {
    dispatch_semaphore_wait(_lock, DISPATCH_TIME_FOREVER);
    id result = [self.containerXQ objectAtIndex:index];;
    dispatch_semaphore_signal(_lock);
    return result;
}

- (id)firstObject {
    dispatch_semaphore_wait(_lock, DISPATCH_TIME_FOREVER);
    id result = [self.containerXQ.backendArray firstObject];
    dispatch_semaphore_signal(_lock);
    return result;
}

- (id)lastObject {
    dispatch_semaphore_wait(_lock, DISPATCH_TIME_FOREVER);
    id result = [self.containerXQ.backendArray lastObject];
    dispatch_semaphore_signal(_lock);
    return result;
}

- (BOOL)containsObject:(id)obj {
    dispatch_semaphore_wait(_lock, DISPATCH_TIME_FOREVER);
    BOOL contain = false;
    if (!obj) {
        contain = NO;
    }
    contain = [self.containerXQ.backendArray containsObject:obj];
    dispatch_semaphore_signal(_lock);
    
    return contain;
}

- (NSInteger)indexOfObject:(id)obj {
    dispatch_semaphore_wait(_lock, DISPATCH_TIME_FOREVER);
    BOOL index = NSNotFound;
    if (obj) {
        index = [self.containerXQ.backendArray indexOfObject:obj];
    }
    dispatch_semaphore_signal(_lock);
    return index;
}

- (NSArray *)allItems {
    dispatch_semaphore_wait(_lock, DISPATCH_TIME_FOREVER);
    NSArray *items = [self.containerXQ backendArray];
    dispatch_semaphore_signal(_lock);
    return items;
}

- (NSMutableArray *)allItemsMutable {
    dispatch_semaphore_wait(_lock, DISPATCH_TIME_FOREVER);
    NSMutableArray *result = [NSMutableArray arrayWithArray:self.allItems];
    dispatch_semaphore_signal(_lock);
    
    return result;
}

- (void)addObjectsFromArray:(NSArray *)otherArray {
    dispatch_semaphore_wait(_lock, DISPATCH_TIME_FOREVER);
    NSInteger lastIndex = [self.containerXQ countOfBackendArray];
    
    NSMutableIndexSet *indexSet = [NSMutableIndexSet indexSet];
    for (int i = 0; i < otherArray.count; i++) {
        [indexSet addIndex:i + lastIndex];
    }
    
    [self.containerXQ insertBackendArray:otherArray atIndexes:indexSet];
    dispatch_semaphore_signal(_lock);
}

- (void)insertObject:(id)anObject atIndex:(NSUInteger)index {
    dispatch_semaphore_wait(_lock, DISPATCH_TIME_FOREVER);
    NSInteger realIndex =index;
    NSInteger count = [self.containerXQ countOfBackendArray];
    if (realIndex >= count) {
        realIndex = count;
    }
    
    [self.containerXQ insertObject:anObject inBackendArrayAtIndex:realIndex];
    dispatch_semaphore_signal(_lock);
}

- (void)insertObjects:(NSArray *)objects atIndexes:(NSIndexSet *)indexes {
    dispatch_semaphore_wait(_lock, DISPATCH_TIME_FOREVER);
    [self.containerXQ insertBackendArray:objects atIndexes:indexes];
    dispatch_semaphore_signal(_lock);
}

- (void)removeObject:(id)object {
    dispatch_semaphore_wait(_lock, DISPATCH_TIME_FOREVER);
    NSUInteger index = [self.containerXQ indexOfObject:object];
    if (index != NSNotFound) {
        [self.containerXQ removeObjectFromBackendArrayAtIndex:index];
    }
    dispatch_semaphore_signal(_lock);
}

- (void)removeLastObject {
    dispatch_semaphore_wait(_lock, DISPATCH_TIME_FOREVER);
    NSInteger lastIndex = [self.containerXQ countOfBackendArray] - 1;
    if (lastIndex >= 0) {
        [self.containerXQ removeObjectFromBackendArrayAtIndex:lastIndex];
    }
    dispatch_semaphore_signal(_lock);
}

- (void)removeObjectAtIndex:(NSUInteger)index {
//    [self performSelector:<#(SEL)#> withObject:<#(id)#> withObject:<#(id)#>]
    
    dispatch_semaphore_wait(_lock, DISPATCH_TIME_FOREVER);
    [self.containerXQ removeObjectFromBackendArrayAtIndex:index];
    dispatch_semaphore_signal(_lock);
}

- (void)replaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject {
    dispatch_semaphore_wait(_lock, DISPATCH_TIME_FOREVER);
    [self.containerXQ replaceObjectInBackendArrayAtIndex:index withObject:anObject];
    dispatch_semaphore_signal(_lock);
}

- (void)switchObjectAtIndex:(NSUInteger)index1 withObjectAtIndex:(NSUInteger)index2 {
    dispatch_semaphore_wait(_lock, DISPATCH_TIME_FOREVER);
    id obj1 = [self.containerXQ objectAtIndex:index1];
    id obj2 = [self.containerXQ objectAtIndex:index2];
    
    NSMutableIndexSet *set = [NSMutableIndexSet indexSet];
    [set addIndex:index1];
    [set addIndex:index2];
    [self.containerXQ replaceBackendArrayAtIndexes:set withBackendArray:@[obj2, obj1]];
    dispatch_semaphore_signal(_lock);
}

- (void)replaceObjectsAtIndexes:(NSIndexSet *)indexes withObjects:(NSArray *)objects {
    dispatch_semaphore_wait(_lock, DISPATCH_TIME_FOREVER);
    [self.containerXQ replaceBackendArrayAtIndexes:indexes withBackendArray:objects];
    dispatch_semaphore_signal(_lock);
}

- (void)removeAllObjects {
    dispatch_semaphore_wait(_lock, DISPATCH_TIME_FOREVER);
    NSInteger count = [self.containerXQ countOfBackendArray];
    if (count > 0) {
        NSMutableIndexSet *set = [NSMutableIndexSet indexSet];
        for (int i = 0; i < count; i++) {
            [set addIndex:i];
        }
        [self.containerXQ removeBackendArrayAtIndexes:set];
    }
    dispatch_semaphore_signal(_lock);
}

- (void)resetByArray:(NSArray *)array {
    dispatch_semaphore_wait(_lock, DISPATCH_TIME_FOREVER);
    self.containerXQ.backendArray = [NSMutableArray arrayWithArray:array];
    dispatch_semaphore_signal(_lock);
}

- (void)setup {
    _lock = dispatch_semaphore_create(1);
    self.containerXQ = [[XQKVContainer alloc] init];
    
    [self.containerXQ addObserver:self forKeyPath:@"backendArray" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {

    NSInteger kind = [change[@"kind"] integerValue];
    NSArray *new = change[@"new"];
    NSArray *old = change[@"old"];
    NSIndexSet *set = change[@"indexes"];
    if (self.changeBlock) {
        self.changeBlock(kind, set, new, old, self.containerXQ.backendArray);
    }
}

+ (void)networkRequestThreadEntryPoint:(id)__unused object {
    @autoreleasepool {
        [[NSThread currentThread] setName:@"XQOperation"];
        
        NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
        [runLoop addPort:[NSMachPort port] forMode:NSDefaultRunLoopMode];
        [runLoop run];
    }
}

+ (NSThread *)networkRequestThread {
    static NSThread *_networkRequestThread = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _networkRequestThread = [[NSThread alloc] initWithTarget:self selector:@selector(networkRequestThreadEntryPoint:) object:nil];
        [_networkRequestThread start];
    });
    
    return _networkRequestThread;
}

@end

//
//  XQKVOMutableArrayTests.m
//  XQKit
//
//  Created by Lunkr on 16/6/2.
//  Copyright © 2016年 XQ. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "XQKVOMutableArray.h"

@interface XQKVOMutableArrayTests : XCTestCase

@property (strong, nonatomic) XQKVOMutableArray *array;

@end

@implementation XQKVOMutableArrayTests

- (void)setUp {
    [super setUp];
    
    self.array = [[XQKVOMutableArray alloc] initWithChangeBlock:^(NSKeyValueChange change, NSIndexSet *indexes, NSArray *newValues, NSArray *oldValues, NSArray  *totalItems) {
        if (change == NSKeyValueChangeSetting) {
            XCTAssertTrue(newValues.count == totalItems.count);
            XCTAssertTrue([newValues.firstObject isEqualToString:totalItems.firstObject]);
            XCTAssertTrue([newValues.lastObject isEqualToString:totalItems.lastObject]);
        } else if (change == NSKeyValueChangeInsertion) {
            __block NSInteger flag = 0;
            [indexes enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL * _Nonnull stop) {
                XCTAssertTrue([totalItems[idx] isEqualToString:newValues[flag++]]);
            }];
        } else if (change == NSKeyValueChangeRemoval) {
//            [indexes enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL * _Nonnull stop) {
//                if (idx < totalItems.count) {
//                    XCTAssertTrue(indexes)
//                }
//            }];
        } else if (change == NSKeyValueChangeReplacement) {
            __block NSInteger flag = 0;
            [indexes enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL * _Nonnull stop) {
                XCTAssertTrue([totalItems[idx] isEqualToString:newValues[flag++]]);
            }];
        }
    }];
    
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
    
//    self.array = nil;
}

- (void)testExample {
    
    NSInteger max = 100;
    do {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self.array addObject:@"1"];
            [self.array addObject:@"2"];
            [self.array addObject:@"3"];
            [self.array addObject:@"4"];
            
            XCTAssertTrue([self.array.lastObject isEqualToString:@"4"]);
        });
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self.array addObject:@"5"];
            [self.array addObject:@"6"];
            [self.array addObject:@"7"];
            [self.array addObject:@"8"];
            [self.array addObject:@"9"];
            [self.array removeLastObject];
            XCTAssertFalse([self.array.lastObject isEqualToString:@"8"]);
        });
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSInteger count = self.array.count;
            [self.array addObject:@"3"];
            XCTAssertTrue(self.array.count == count + 1);
        });
        max--;
    } while (max>=0);
}


@end

//
//  XQSafeTests.m
//  XQKit
//
//  Created by Bill on 16/5/27.
//  Copyright © 2016年 XQ. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "XQSafe.h"

@interface XQSafeTests : XCTestCase

@end

@implementation XQSafeTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testNSObjectSafeObjectForKey {
    
    NSNull *null = [NSNull null];
    XCTAssertNil([null safeObjectForKey:@"aKey"]);
    
    NSArray *array = [NSArray array];
    XCTAssertNil([array safeObjectForKey:@"aKey"]);
    
    NSObject *obj = [[NSObject alloc] init];
    XCTAssertNil([obj safeObjectForKey:@"aKey"]);
}

- (void)testNSDictionaryXQSafe {
    NSDictionary *dict1 = @{@"key1":@"value1", @"key2":@"value2"};
    NSDictionary *result1 = [dict1 safeRemoveNull];
    
    XCTAssertEqual(@"value1", result1[@"key1"]);
    XCTAssertEqual(@"value2", result1[@"key2"]);
    
    NSDictionary *dict2 = @{@"key1":[NSNull null], @"key2":@"value2"};
    NSDictionary *result2 = [dict2 safeRemoveNull];
    XCTAssertNil(result2[@"key1"]);
    XCTAssertEqual(@"value2", result2[@"key2"]);
    
    NSDictionary *dict3 = @{@"key1":[NSNull null], @"key2":[NSNull null]};
    NSDictionary *result3 = [dict3 safeRemoveNull];
    XCTAssertNil(result3[@"key1"]);
    XCTAssertNil(result3[@"key2"]);
}

- (void)testNSMutableDictionXQSafe {
    NSMutableDictionary *dict1 = [@{@"key1":@"value1", @"key2":@"value2"} mutableCopy];
    NSMutableDictionary *result1 = [dict1 safeRemoveNull];
    
    XCTAssertEqual(@"value1", result1[@"key1"]);
    XCTAssertEqual(@"value2", result1[@"key2"]);
    XCTAssertTrue([result1 isKindOfClass:[NSMutableDictionary class]]);
    
    NSMutableDictionary *dict2 = [@{@"key1":[NSNull null], @"key2":@"value2"} mutableCopy];
    NSMutableDictionary *result2 = [dict2 safeRemoveNull];
    XCTAssertNil(result2[@"key1"]);
    XCTAssertEqual(@"value2", result2[@"key2"]);
    XCTAssertTrue([result2 isKindOfClass:[NSMutableDictionary class]]);
    
    NSMutableDictionary *dict3 = [@{@"key1":[NSNull null], @"key2":[NSNull null]} mutableCopy];
    NSMutableDictionary *result3 = [dict3 safeRemoveNull];
    XCTAssertNil(result3[@"key1"]);
    XCTAssertNil(result3[@"key2"]);
    XCTAssertTrue([result3 isKindOfClass:[NSMutableDictionary class]]);
}

- (void)testNSArrayXQSafe {
    NSArray *array1 = @[@"1", @"2"];
    NSArray *result1 = [array1 safeRemoveNull];
    XCTAssertTrue([result1 containsObject:@"1"]);
    XCTAssertTrue([result1 containsObject:@"2"]);
    
    NSArray *array2 = @[@"1", [NSNull null]];
    NSArray *result2 = [array2 safeRemoveNull];
    XCTAssertTrue([result2 containsObject:@"1"]);
    XCTAssertTrue(result2.count == 1);
    
    NSArray *array3 = @[[NSNull null], [NSNull null]];
    NSArray *result3 = [array3 safeRemoveNull];
    XCTAssertTrue(result3.count == 0);
    
}

- (void)testMutableArrayXQSafe {
    NSMutableArray *array1 = [@[@"1", @"2"] mutableCopy];
    NSMutableArray *result1 = [array1 safeRemoveNull];
    XCTAssertTrue([result1 containsObject:@"1"]);
    XCTAssertTrue([result1 containsObject:@"2"]);
    
    NSMutableArray *array2 = [@[@"1", [NSNull null]] mutableCopy];
    NSMutableArray *result2 = [array2 safeRemoveNull];
    XCTAssertTrue([result2 containsObject:@"1"]);
    XCTAssertTrue(result2.count == 1);
    XCTAssertTrue([result2 isKindOfClass:[NSMutableArray class]]);
    
    NSMutableArray *array3 = [@[[NSNull null], [NSNull null]] mutableCopy];
    NSMutableArray *result3 = [array3 safeRemoveNull];
    XCTAssertTrue(result3.count == 0);
    XCTAssertTrue([result3 isKindOfClass:[NSMutableArray class]]);
}

- (void)testXQSafe {
    NSArray *array1 = @[@"1", @"2", @{@"3":[NSNull null], @"4":@"value4"}, [NSNull null]];
    NSArray *result1 = [array1 safeRemoveNull];
    XCTAssertTrue([result1 containsObject:@"1"]);
    XCTAssertTrue([result1 containsObject:@"2"]);
    
    NSArray *array2 = @[@"1", @"2", @{@"3":[NSNull null], @"4":@"value4"}, [NSNull null]];
    NSArray *result2 = [array2 safeRemoveNull];
    XCTAssertTrue([result2 containsObject:@"1"]);
    
    NSArray *array3 = @[@"1", @"2", @{@"3":[NSNull null], @"4":@"value4"}, [NSNull null]];
    NSArray *result3 = [array3 safeRemoveNull];
    XCTAssertTrue(result3.count == 3);
    NSDictionary *item2 = result3[2];
    XCTAssertTrue(item2.count == 1);
    XCTAssertEqual(@"value4", item2[@"4"]);
}

- (void)testSafeSetObject {
    NSMutableDictionary *dict2 = [@{} mutableCopy];
    [dict2 safeSetObject:nil forKey:@"key"];
    XCTAssertNil(dict2[@"key"]);
    
    [dict2 safeSetObject:@"" forKey:nil];
    XCTAssertNil(dict2[@"key"]);
    
    [dict2 safeSetObject:@"v1" forKey:@"k1"];
    XCTAssertEqual(dict2[@"k1"], @"v1");
    
    [dict2 safeSetObject:nil forKey:@"k2" nilToBlank:false];
    XCTAssertNil(dict2[@"k2"]);
    
    [dict2 safeSetObject:nil forKey:@"k3" nilToBlank:true];
    XCTAssertEqual(@"", dict2[@"k3"]);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end

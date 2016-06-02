//
//  AppDelegate.m
//  XQKit
//
//  Created by Bill on 16/5/27.
//  Copyright © 2016年 XQ. All rights reserved.
//

#import "AppDelegate.h"
#import "XQKVOMutableArray.h"

@interface AppDelegate ()

@property (strong, nonatomic) XQKVOMutableArray *array;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    __weak typeof(self) weakSelf = self;
    self.array = [[XQKVOMutableArray alloc] initWithChangeBlock:^(NSKeyValueChange change, NSIndexSet *indexes, NSArray *newValues, NSArray *oldValues, NSArray *allObjects) {
        if (change == NSKeyValueChangeSetting) {
            NSAssert(newValues.count == allObjects.count, nil);
        } else if (change == NSKeyValueChangeInsertion) {
            __block NSInteger flag = 0;
            [indexes enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL * _Nonnull stop) {
                NSAssert([allObjects[idx] isEqualToString:newValues[flag++]], nil);
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
                NSAssert([allObjects[idx] isEqualToString:newValues[flag++]], nil);
            }];
        }
        
        
//        NSLog(@"\n%i> %@\n%@",change,[newValues lastObject], allObjects);
    }];
    
    [self testExample];
    
    // Override point for customization after application launch.
    return YES;
}

- (void)testExample {
    
    NSInteger max = 100;
    do {
        
//        [self.array addObject:@"1"];
//        [self.array addObject:@"2"];
//        [self.array addObject:@"3"];
//        [self.array addObject:@"4"];
//        [self.array addObject:@"5"];
//        [self.array addObject:@"6"];
//        [self.array addObject:@"7"];
//        [self.array addObject:@"8"];
//        [self.array addObject:@"9"];
//        [self.array resetByArray:nil];
//        [self.array insertObject:@"100" atIndex:1000];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self.array addObject:@"1"];
        });
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self.array addObject:@"2"];
        });
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self.array addObject:@"3"];
        });
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self.array addObject:@"4"];
        });
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self.array addObject:@"5"];
        });
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self.array addObject:@"6"];
        });
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self.array addObject:@"7"];
        });
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self.array addObject:@"8"];
        });
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self.array removeLastObject];
        });
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self.array insertObject:@"0" atIndex:0];
            [self.array replaceObjectAtIndex:0 withObject:@"8"];
        });
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self.array resetByArray:nil];
            [self.array insertObject:@"0" atIndex:1000];
        });
        NSLog(@"::%@", self.array.allItems);
        
        max--;
    } while (max>=0);
}



- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end

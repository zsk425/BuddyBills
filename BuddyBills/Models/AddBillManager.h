//
//  AddBillManager.h
//  BuddyBills
//
//  Created by zhaosk on 14-2-23.
//  Copyright (c) 2014年 zhaosk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AddBillManager : NSObject

@property (nonatomic, strong) NSString *activityName;
@property (nonatomic, strong) NSDate *activityDate;
@property (nonatomic, assign) float cost;
@property (nonatomic, assign) NSUInteger buddiesCount;
@property (nonatomic, assign) BOOL isAA;
@property (nonatomic, strong) NSString *notes;
@property (nonatomic, strong) NSMutableArray *buddyBills;

+ (AddBillManager *)sharedInstance;

#pragma mark - Functions
+ (NSArray *)fetchAllBuddies;

- (void)clear;
@end

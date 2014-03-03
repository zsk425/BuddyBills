//
//  BuddyBill.h
//  BuddyBills
//
//  Created by zhaosk on 14-3-1.
//  Copyright (c) 2014年 zhaosk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Bill, Buddy;

@interface BuddyBill : NSManagedObject

@property (nonatomic, retain) NSNumber * currentPayed;
@property (nonatomic, retain) NSNumber * needToPay;
@property (nonatomic, retain) Bill *bill;
@property (nonatomic, retain) Buddy *buddy;

@end

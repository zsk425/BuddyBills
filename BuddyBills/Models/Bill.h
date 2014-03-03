//
//  Bill.h
//  BuddyBills
//
//  Created by zhaosk on 14-3-1.
//  Copyright (c) 2014年 zhaosk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class BuddyBill;

@interface Bill : NSManagedObject

@property (nonatomic, retain) NSDate * activityDate;
@property (nonatomic, retain) NSString * activityName;
@property (nonatomic, retain) NSNumber * cost;
@property (nonatomic, retain) NSNumber * isAA;
@property (nonatomic, retain) NSString * notes;
@property (nonatomic, retain) NSSet *buddyBills;
@end

@interface Bill (CoreDataGeneratedAccessors)

- (void)addBuddyBillsObject:(BuddyBill *)value;
- (void)removeBuddyBillsObject:(BuddyBill *)value;
- (void)addBuddyBills:(NSSet *)values;
- (void)removeBuddyBills:(NSSet *)values;

@end

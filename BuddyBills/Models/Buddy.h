//
//  Buddy.h
//  BuddyBills
//
//  Created by zhaosk on 14-3-1.
//  Copyright (c) 2014年 zhaosk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class BuddyBill;

@interface Buddy : NSManagedObject

@property (nonatomic, retain) NSDate * cteated_at;
@property (nonatomic, retain) NSNumber * money;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *bills;
@end

@interface Buddy (CoreDataGeneratedAccessors)

- (void)addBillsObject:(BuddyBill *)value;
- (void)removeBillsObject:(BuddyBill *)value;
- (void)addBills:(NSSet *)values;
- (void)removeBills:(NSSet *)values;

@end

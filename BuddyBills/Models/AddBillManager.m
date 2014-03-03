//
//  AddBillManager.m
//  BuddyBills
//
//  Created by zhaosk on 14-2-23.
//  Copyright (c) 2014年 zhaosk. All rights reserved.
//

#import "AddBillManager.h"
@import CoreData;

@implementation AddBillManager

+ (AddBillManager *)sharedInstance {
    static dispatch_once_t once;
    static AddBillManager *sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

- (id)init
{
    if (self = [super init])
    {
        _buddyBills = [NSMutableArray arrayWithCapacity:0];
    }
    
    return self;
}

#pragma mark - Functions
+ (NSArray *)fetchAllBuddies
{
    NSError *error;
    NSManagedObjectContext *context = [[SDCoreDataController sharedInstance] masterManagedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Buddy"
                                              inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    return [context executeFetchRequest:fetchRequest error:&error];
}

- (void)clear
{
    self.activityName = nil;
    self.activityDate = nil;
    self.cost = 0.0;
    self.isAA = NO;
    self.notes = nil;
    [self.buddyBills removeAllObjects];
}
@end

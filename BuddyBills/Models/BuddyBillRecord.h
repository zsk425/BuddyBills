//
//  BuddyBillRecord.h
//  BuddyBills
//
//  Created by zhaosk on 14-2-23.
//  Copyright (c) 2014年 zhaosk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BuddyBillRecord : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) float needPay;
@property (nonatomic, assign) float currentPayed;

@end

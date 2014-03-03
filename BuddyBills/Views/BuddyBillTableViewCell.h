//
//  BuddyBillTableViewCell.h
//  BuddyBills
//
//  Created by zhaosk on 14-2-23.
//  Copyright (c) 2014年 zhaosk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BuddyBillTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *needPay;
@property (weak, nonatomic) IBOutlet UILabel *currentPayed;

@end

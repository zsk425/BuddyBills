//
//  DetailBillViewController.m
//  BuddyBills
//
//  Created by zhaosk on 14-3-1.
//  Copyright (c) 2014年 zhaosk. All rights reserved.
//

#import "DetailBillViewController.h"
#import "Bill.h"
#import "Buddy.h"
#import "BuddyBill.h"
#import "BuddyBillTableViewCell.h"

@interface DetailBillViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSArray *buddyBills;

@property (weak, nonatomic) IBOutlet UILabel *cost;
@property (weak, nonatomic) IBOutlet UILabel *activityDate;
@property (weak, nonatomic) IBOutlet UILabel *buddiesCount;
@property (weak, nonatomic) IBOutlet UILabel *isAA;

@property (weak, nonatomic) IBOutlet UITextView *notes;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *activityName;
@end

@implementation DetailBillViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.activityName.text = self.bill.activityName;
    self.cost.text = [self.bill.cost stringValue];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    self.activityDate.text = [formatter stringFromDate:self.bill.activityDate];
    self.buddiesCount.text = [@([self.bill.buddyBills count]) stringValue];
    self.isAA.text = self.bill.isAA.boolValue ? @"是" : @"否";
    self.notes.text = self.bill.notes;
    
    self.buddyBills = [self.bill.buddyBills allObjects];
    
    //添加TableView Header
    UIView *tableViewHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frameSizeWidth, 44)];
    tableViewHeader.backgroundColor = [UIColor cloudsColor];
    [tableViewHeader addSubview:({
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 80, 43)];
        label.text = @"姓名";
        label.textAlignment = NSTextAlignmentCenter;
        label;
    })];
    [tableViewHeader addSubview:({
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(120, 0, 80, 43)];
        label.text = @"应付";
        label.textAlignment = NSTextAlignmentCenter;
        label;
    })];
    [tableViewHeader addSubview:({
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(220, 0, 80, 43)];
        label.text = @"实付";
        label.textAlignment = NSTextAlignmentCenter;
        label;
    })];
    self.tableView.tableHeaderView = tableViewHeader;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.bill.buddyBills count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    
    BuddyBillTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    //调整UI
    [cell configureFlatCellWithColor:[UIColor greenSeaColor] selectedColor:[UIColor cloudsColor]];
    cell.cornerRadius = 5.0f;
    cell.separatorHeight = 2.0f;
    
    BuddyBill *buddyBill = self.buddyBills[indexPath.row];
    Buddy *buddy = buddyBill.buddy;
    cell.name.text = buddy.name;
    cell.needPay.text = [buddyBill.needToPay stringValue];
    cell.currentPayed.text = [buddyBill.currentPayed stringValue];
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


@end

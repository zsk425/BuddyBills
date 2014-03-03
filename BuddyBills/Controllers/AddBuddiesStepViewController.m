//
//  AddBuddiesStepViewController.m
//  BuddyBills
//
//  Created by zhaosk on 14-2-23.
//  Copyright (c) 2014年 zhaosk. All rights reserved.
//

#import "AddBuddiesStepViewController.h"
#import "BuddyBillTableViewCell.h"
#import "BuddyBillRecord.h"
#import "Buddy.h"
#import "Bill.h"
#import "BuddyBill.h"
#import "AddBillManager.h"
#import "SDCoreDataController.h"
#import <RMStepsController/RMStepsController.h>
@import CoreData;

@interface AddBuddiesStepViewController ()<UITableViewDataSource,UIPickerViewDataSource, UIPickerViewDelegate>
{
    NSMutableArray *_buddies;
    NSMutableArray *_buddyBills;
    NSManagedObjectContext *_context;
    
    CGFloat _cost;
    NSInteger _pickerSelectedIndex;
    NSMutableArray *_addedBuddies;      //记录已将添加过的小伙伴，方便在删除添加后重新恢复picker中的数据
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *buddy;
@property (weak, nonatomic) IBOutlet UITextField *needPay;
@property (weak, nonatomic) IBOutlet UITextField *currentPayed;
@property (weak, nonatomic) IBOutlet UIPickerView *buddyPicker;
@property (weak, nonatomic) IBOutlet UIButton *addBuddyBillBtn;
@property (weak, nonatomic) IBOutlet UIScrollView *scrolView;

@end

@implementation AddBuddiesStepViewController

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
    
    if ([AddBillManager sharedInstance].isAA)
    {
        CGFloat perCost = [AddBillManager sharedInstance].cost / [AddBillManager sharedInstance].buddiesCount;
        self.needPay.text = [NSString stringWithFormat:@"%.1f",perCost];
        self.needPay.enabled = NO;
    }
    
    _pickerSelectedIndex = -1;
    
    _cost = [AddBillManager sharedInstance].cost;
    
    _context = [SDCoreDataController sharedInstance].masterManagedObjectContext;
    
    _addedBuddies = [NSMutableArray arrayWithCapacity:0];
    _buddies = [NSMutableArray arrayWithArray:[AddBillManager fetchAllBuddies]];
    _buddyBills = [AddBillManager sharedInstance].buddyBills;
    [_buddyBills removeAllObjects];
    
    //添加手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self.view addGestureRecognizer:tap];
    
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
    
    //注册键盘出现通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_buddyBills count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell";
    
    BuddyBillTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    //调整UI
    [cell configureFlatCellWithColor:[UIColor greenSeaColor] selectedColor:[UIColor cloudsColor]];
    cell.cornerRadius = 5.0f;
    cell.separatorHeight = 2.0f;
    
    BuddyBillRecord *record = _buddyBills[indexPath.row];
    cell.name.text = record.name;
    cell.needPay.text = [NSString stringWithFormat:@"%.2f",record.needPay];
    cell.currentPayed.text = [NSString stringWithFormat:@"%.2f",record.currentPayed];
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

//完成编辑
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_buddyBills removeObjectAtIndex:indexPath.row];
    [_buddies addObject: [_addedBuddies objectAtIndex:indexPath.row]];
    [_addedBuddies removeObjectAtIndex:indexPath.row];
    [tableView reloadData];
    [self.buddyPicker reloadAllComponents];
}

#pragma mark - UITalbeView delegate
//可编辑样式
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}


#pragma mark - UI Events
- (void)handleTap:(UITapGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateEnded)
    {
        [self.view endEditing:YES];
        [self hidePicker];
    }
}

- (IBAction)onAddBuddyBill:(id)sender
{
    if (_pickerSelectedIndex == -1)
    {
        [TSMessage showNotificationInViewController:self.navigationController title:@"" subtitle:@"不选人就不要瞎点" type:TSMessageNotificationTypeError];
        return;
    }
    
    BuddyBillRecord *record = [[BuddyBillRecord alloc] init];
    record.name = self.buddy.titleLabel.text;
    record.needPay = [self.needPay.text floatValue];
    record.currentPayed = [self.currentPayed.text floatValue];
    
    [_buddyBills addObject:record];
    [self.tableView reloadData];
    
    //将已添加的小伙伴保存
    [_addedBuddies addObject:[_buddies objectAtIndex:_pickerSelectedIndex]];
    //将此小伙伴从picker中移除
    [_buddies removeObjectAtIndex:_pickerSelectedIndex];
    [self.buddyPicker reloadAllComponents];
    
    _pickerSelectedIndex = -1;
    [self.buddy setTitle:@"请选择" forState:UIControlStateNormal];
}


- (IBAction)onComplete:(id)sender
{
    //判断金额是否无误
    __block CGFloat needPaySum = 0.0;
    __block CGFloat payedSum = 0.0;
    [_buddyBills enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        BuddyBillRecord *record = (BuddyBillRecord *)obj;
        needPaySum += record.needPay;
        payedSum += record.currentPayed;
    }];
    if (needPaySum - _cost != 0 || needPaySum - payedSum != 0)
    {
        [TSMessage showNotificationInViewController:self.navigationController title:@"算错帐了" subtitle:@"应付金额和实付金额不匹配" type:TSMessageNotificationTypeError];
        return;
    }
    
    
    AddBillManager *manager = [AddBillManager sharedInstance];
    
    Bill *bill = [NSEntityDescription insertNewObjectForEntityForName:@"Bill" inManagedObjectContext:_context];
    bill.activityName = manager.activityName;
    bill.activityDate = manager.activityDate;
    bill.cost = [NSNumber numberWithFloat:manager.cost];
    bill.isAA = [NSNumber numberWithBool:manager.isAA];
    bill.notes = manager.notes;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [_buddyBills enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        BuddyBillRecord *record = (BuddyBillRecord *)obj;
        BuddyBill *buddyBill = [NSEntityDescription insertNewObjectForEntityForName:@"BuddyBill" inManagedObjectContext:_context];
        buddyBill.needToPay = [NSNumber numberWithFloat:record.needPay];
        buddyBill.currentPayed = [NSNumber numberWithFloat:record.currentPayed];
        [buddyBill setBill:bill];
        
        //查询出Buddy
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Buddy" inManagedObjectContext:_context];
        [fetchRequest setEntity:entity];
        [fetchRequest setFetchLimit:1];
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"name == %@", record.name];
        [fetchRequest setPredicate:pred];
        NSError *error;
        Buddy *buddy = (Buddy *)[[_context executeFetchRequest:fetchRequest error:&error] lastObject];
        float money = [buddy.money floatValue];
        money = money - record.needPay + record.currentPayed;
        buddy.money = [NSNumber numberWithFloat:money];
        
        [buddyBill setBuddy:buddy];
        [bill addBuddyBillsObject:buddyBill];
        [buddy addBillsObject:buddyBill];
    }];
    
    NSError *error2;
    if (![_context save:&error2]) {
        [TSMessage showNotificationInViewController:self title:@"保存数据出错" subtitle:@"" type:TSMessageNotificationTypeError];
    }
    
    //清理数据
    [[AddBillManager sharedInstance] clear];
    
    //跳转到Main View
    [self.stepsController finishedAllSteps];
}

- (void) showPicker
{
    
    [self.view endEditing:YES];
    
    [self.scrolView setContentOffset:CGPointMake(0, 150) animated:YES];
    [UIView animateKeyframesWithDuration:0.5 delay:0 options:UIViewKeyframeAnimationOptionBeginFromCurrentState animations:^{
        self.buddyPicker.frameOriginY = self.view.frameSizeHeight - 216;
    } completion:^(BOOL finished) {
        //TODO
    }];
    
}

- (void) hidePicker
{
    [self.scrolView setContentOffset:CGPointMake(0, 0) animated:YES];
    [UIView animateKeyframesWithDuration:0.5 delay:0 options:UIViewKeyframeAnimationOptionBeginFromCurrentState animations:^{
        self.buddyPicker.frameOriginY = self.view.frameSizeHeight;
    } completion:^(BOOL finished) {
        //TODO
    }];
}

- (IBAction)chooseBuddy:(id)sender
{
    [self showPicker];
}

#pragma mark - UIPickerView DataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [_buddies count];
}

#pragma - UIPickerView Delegate
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    Buddy *buddy = (Buddy *)_buddies[row];
    
    return buddy.name;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    _pickerSelectedIndex = row;
    Buddy *buddy = (Buddy *)_buddies[row];
    [self.buddy setTitle:buddy.name forState:UIControlStateNormal];
    self.addBuddyBillBtn.enabled = YES;
    [self hidePicker];
}

#pragma mark - Keyboard Events
- (void)keyboardWillShow:(NSNotification *)notif {
    
    CGRect rect = [[notif.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.25];
    self.view.frameOriginY -= CGRectGetHeight(rect);
    [UIView commitAnimations];
}

- (void)keyboardWillHide:(NSNotification *)notif {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.25];
    self.view.frameOriginY = 0;
    [UIView commitAnimations];
}


@end

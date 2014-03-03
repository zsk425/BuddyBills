//
//  AddBasicInfoStepViewController.m
//  BuddyBills
//
//  Created by zhaosk on 14-2-23.
//  Copyright (c) 2014年 zhaosk. All rights reserved.
//

#import "AddBasicInfoStepViewController.h"
#import <RMStepsController/RMStepsController.h>
#import "AddBillManager.h"

@interface AddBasicInfoStepViewController ()

@property (strong, nonatomic) FUISwitch *isAA;

@property (weak, nonatomic) IBOutlet UITextField *activityName;
@property (weak, nonatomic) IBOutlet UIButton *activityDate;
@property (weak, nonatomic) IBOutlet UITextField *cost;
@property (weak, nonatomic) IBOutlet UITextView *notes;
@property (weak, nonatomic) IBOutlet UITextField *buddiesCount;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

@end

@implementation AddBasicInfoStepViewController

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
	
    self.isAA = [[FUISwitch alloc] initWithFrame:CGRectMake(171, 305, 81, 31)];
    //调整UI
    {
        self.isAA.onColor = [UIColor turquoiseColor];
        self.isAA.offColor = [UIColor cloudsColor];
        self.isAA.onBackgroundColor = [UIColor midnightBlueColor];
        self.isAA.offBackgroundColor = [UIColor silverColor];
        self.isAA.offLabel.font = [UIFont boldFlatFontOfSize:14];
        self.isAA.onLabel.font = [UIFont boldFlatFontOfSize:14];
    }
    [self.view addSubview:self.isAA];
    
    //添加手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self.view addGestureRecognizer:tap];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [self.activityDate setTitle:[formatter stringFromDate:self.datePicker.date] forState:UIControlStateNormal];
    
    [self.datePicker addTarget:self
                                   action:@selector(dateHasChanged:)
                         forControlEvents:UIControlEventValueChanged];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI Events

- (void) showPicker {
    
    [self.view endEditing:YES];
    
    [UIView animateKeyframesWithDuration:0.5 delay:0 options:UIViewKeyframeAnimationOptionBeginFromCurrentState animations:^{
        self.datePicker.frameOriginY = self.view.frameSizeHeight - 216;
    } completion:^(BOOL finished) {
        //TODO
    }];
    
}

- (void) hidePicker {
    [UIView animateKeyframesWithDuration:0.5 delay:0 options:UIViewKeyframeAnimationOptionBeginFromCurrentState animations:^{
        self.datePicker.frameOriginY = self.view.frameSizeHeight;
    } completion:^(BOOL finished) {
        //TODO
    }];
}

- (void)dateHasChanged:(id) sender {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [self.activityDate setTitle:[formatter stringFromDate:self.datePicker.date] forState:UIControlStateNormal];
}

- (void)handleTap:(UITapGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateEnded)
    {
        [self.view endEditing:YES];
        [self hidePicker];
    }
}
- (IBAction)onDateBtn:(id)sender
{
    [self showPicker];
}

- (IBAction)onNextStep:(id)sender
{
    NSString *activityName = [self.activityName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *cost = [self.cost.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSInteger buddiesCount = [[self.buddiesCount.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] integerValue];
    if (activityName.length == 0 || cost.length == 0 || buddiesCount == 0)
    {
        [TSMessage showNotificationInViewController:self.navigationController title:@"输入格式有误" subtitle:@"" type:TSMessageNotificationTypeError];
        return;
    }
    
    //存储这一步所有信息
    AddBillManager *manager = [AddBillManager sharedInstance];
    manager.activityName = activityName;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    manager.activityDate = [formatter dateFromString:self.activityDate.titleLabel.text];
    manager.buddiesCount = buddiesCount;
    manager.isAA = self.isAA.on;
    manager.cost = [cost floatValue];
    manager.notes = self.notes.text;
    
    //跳转
    [self.stepsController showNextStep];
}


@end

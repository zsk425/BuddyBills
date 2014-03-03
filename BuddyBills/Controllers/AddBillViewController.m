//
//  AddBillViewController.m
//  BuddyBills
//
//  Created by zhaosk on 14-2-23.
//  Copyright (c) 2014年 zhaosk. All rights reserved.
//

#import "AddBillViewController.h"

@interface AddBillViewController ()

@end

@implementation AddBillViewController

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
	// Do any additional setup after loading the view.
    
    self.stepsBar.seperatorColor = [UIColor cloudsColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Override RMStepsController Some Methods
- (NSArray *)stepViewControllers {
    UIViewController *firstStep = [self.storyboard instantiateViewControllerWithIdentifier:@"AddBasicInfoStepViewController"];
    firstStep.step.title = @"第一步";
    
    UIViewController *secondStep = [self.storyboard instantiateViewControllerWithIdentifier:@"AddBuddiesStepViewController"];
    secondStep.step.title = @"第二步";
    
    return @[firstStep, secondStep];
}

- (void)finishedAllSteps {
    //[self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)canceled {
    //[self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

@end

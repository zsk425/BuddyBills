//
//  MainViewController.m
//  BuddyBills
//
//  Created by zhaosk on 14-2-22.
//  Copyright (c) 2014年 zhaosk. All rights reserved.
//

#import "MainViewController.h"
#import "SDCoreDataController.h"
#import "Buddy.h"
#import <PNChart/PNChart.h>
@import CoreData;

@interface MainViewController ()
{
    NSManagedObjectContext *_context;
}

@end

@implementation MainViewController

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
	
    _context = [SDCoreDataController sharedInstance].masterManagedObjectContext;
    
    //赤字表
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Buddy" inManagedObjectContext:_context];
    NSPredicate *ped = [NSPredicate predicateWithFormat:@"money < 0"];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:ped];
    NSError *error;
    NSArray *arr = [_context executeFetchRequest:fetchRequest error:&error];
    NSMutableArray *nameArr = [NSMutableArray arrayWithCapacity:0];
    NSMutableArray *moneyArr = [NSMutableArray arrayWithCapacity:0];
    [arr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        Buddy *buddy = (Buddy *)obj;
        NSString *name = [buddy.name stringByAppendingString:buddy.money.description];
        [nameArr addObject:name];
        [moneyArr addObject:@(-[buddy.money floatValue])];
    }];
    if ([arr count] != 0) {
        PNBarChart * barChart = [[PNBarChart alloc] initWithFrame:CGRectMake(0, 64.0 + 180 + 30, self.view.frame.size.width, 180.0)];
        [barChart setXLabels:nameArr];
        [barChart setYValues:moneyArr];
        [barChart setStrokeColor:PNRed];
        [barChart strokeChart];
        [self.view addSubview:barChart];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
        [label bottomAlignForView:barChart offset:-20];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"赤字表";
        label.textColor = [UIColor colorWithWhite:0.2 alpha:0.8];
        [self.view addSubview:label];
    }
    
    //余额表
    ped = [NSPredicate predicateWithFormat:@"money >= 0"];
    [fetchRequest setPredicate:ped];
    arr = [_context executeFetchRequest:fetchRequest error:&error];
    [nameArr removeAllObjects];
    [moneyArr removeAllObjects];
    [arr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        Buddy *buddy = (Buddy *)obj;
        NSString *name = [buddy.name stringByAppendingString:buddy.money.description];
        [nameArr addObject:name];
        [moneyArr addObject:buddy.money];
    }];
    
    if ([arr count] != 0) {
        PNBarChart * barChart = [[PNBarChart alloc] initWithFrame:CGRectMake(0, 64.0, self.view.frame.size.width, 180.0)];
        [barChart setXLabels:nameArr];
        [barChart setYValues:moneyArr];
        [barChart strokeChart];
        [barChart setStrokeColor:PNGreen];
        [self.view addSubview:barChart];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
        [label bottomAlignForView:barChart offset:-20];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"余额表";
        label.textColor = [UIColor colorWithWhite:0.2 alpha:0.8];
        [self.view addSubview:label];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI Event

- (IBAction)showMenu:(id)sender
{
    REFrostedViewController *vc = (REFrostedViewController *)[[TMCache sharedCache] objectForKey:FROSTEDVIEWCONTROLLER];
    
    [vc presentMenuViewController];
}
@end

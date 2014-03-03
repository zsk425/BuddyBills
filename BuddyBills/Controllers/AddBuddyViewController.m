//
//  AddBuddyViewController.m
//  BuddyBills
//
//  Created by zhaosk on 14-2-22.
//  Copyright (c) 2014年 zhaosk. All rights reserved.
//

#import "AddBuddyViewController.h"
#import <REFrostedViewController/REFrostedViewController.h>
#import "Buddy.h"
#import "AddBillManager.h"
@import CoreData;

@interface AddBuddyViewController () <UITableViewDataSource>
{
    NSArray *_buddies;
    NSManagedObjectContext *_context;
}

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet FUIButton *addBtn;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation AddBuddyViewController

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
    
    _context = [[SDCoreDataController sharedInstance] masterManagedObjectContext];
    _buddies = [AddBillManager fetchAllBuddies];
    
    //添加手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self.view addGestureRecognizer:tap];
    
    //UI调整
    {
        self.addBtn.buttonColor = [UIColor turquoiseColor];
        self.addBtn.shadowColor = [UIColor greenSeaColor];
        self.addBtn.shadowHeight = 3.0f;
        self.addBtn.cornerRadius = 6.0f;
        self.addBtn.titleLabel.font = [UIFont boldFlatFontOfSize:16];
        [self.addBtn setTitleColor:[UIColor cloudsColor] forState:UIControlStateNormal];
        [self.addBtn setTitleColor:[UIColor cloudsColor] forState:UIControlStateHighlighted];
    }
    
    self.tableView.backgroundColor = [UIColor cloudsColor];
}

//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    self.navigationController.navigationBar.hidden = YES;
//}
//
//- (void)viewWillDisappear:(BOOL)animated
//{
//    [super viewWillDisappear:animated];
//    self.navigationController.navigationBar.hidden = NO;
//}

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

- (IBAction)onAddBuddy:(id)sender
{
    [self.view endEditing:YES];
    
    NSString *name = [_nameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (name.length == 0 || name.length > 20)
    {
        [TSMessage showNotificationInViewController:self.navigationController title:@"姓名格式有误" subtitle:@"" type:TSMessageNotificationTypeError];
        return;
    }
    
    Buddy *newBuddy = [NSEntityDescription insertNewObjectForEntityForName:@"Buddy" inManagedObjectContext:_context];
    newBuddy.name = name;
    newBuddy.cteated_at = [NSDate date];
    newBuddy.money = [NSNumber numberWithFloat:0.0];
    NSError *error;
    if (![_context save:&error])
    {
        if(newBuddy.isInserted)
        {
            NSLog(@"isInserted");
            [_context deleteObject:newBuddy];
        }
        [TSMessage showNotificationInViewController:self.navigationController title:@"添加失败" subtitle:[error localizedDescription] type:TSMessageNotificationTypeError];
    }else
    {
        [TSMessage showNotificationInViewController:self.navigationController title:@"添加成功" subtitle:@"" type:TSMessageNotificationTypeSuccess];
        _buddies = [AddBillManager fetchAllBuddies];
        [_tableView reloadData];
    }
}

- (void)handleTap:(UITapGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateEnded)
    {
        [self.view endEditing:YES];
    }
}

#pragma mark - UITableView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_buddies count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIndentifier = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier forIndexPath:indexPath];
    
    //调整UI
    [cell configureFlatCellWithColor:[UIColor greenSeaColor] selectedColor:[UIColor cloudsColor]];
    cell.cornerRadius = 5.0f;
    cell.separatorHeight = 2.0f;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    Buddy *buddy = [_buddies objectAtIndex:indexPath.row];
    cell.textLabel.text = buddy.name;
    cell.detailTextLabel.text = [buddy.cteated_at descriptionWithLocale:[NSLocale currentLocale]];
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"已经存在的小伙伴";
}

@end

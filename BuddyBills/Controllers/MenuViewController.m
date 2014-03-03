//
//  MenuViewController.m
//  BuddyBills
//
//  Created by zhaosk on 14-2-22.
//  Copyright (c) 2014年 zhaosk. All rights reserved.
//

#import "MenuViewController.h"
#import "AddBuddyViewController.h"
#import "MainViewController.h"
#import "AddBillViewController.h"
#import "HistoryBillsViewController.h"

@interface MenuViewController ()
{
    NSArray *_menuItems;
}

@end

@implementation MenuViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _menuItems = @[@"首页",@"添加小伙伴", @"新建账单",@"历史账单"];
    
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 44 + 20)];
    self.tableView.tableHeaderView.backgroundColor = [UIColor greenSeaColor];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 44 + 150)];
    self.tableView.tableFooterView.backgroundColor = [UIColor greenSeaColor];
    self.tableView.backgroundColor = [UIColor greenSeaColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (tableView.frameSizeHeight - tableView.tableHeaderView.frameSizeHeight - tableView.tableFooterView.frameSizeHeight) / [_menuItems count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_menuItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    [cell configureFlatCellWithColor:[UIColor greenSeaColor] selectedColor:[UIColor cloudsColor]];
    //cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    //cell.cornerRadius = 5.0f; // optional
    //cell.separatorHeight = 2.0f; // optional
    
    cell.textLabel.text = _menuItems[indexPath.row];
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - UITableView delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard *storyBoard = self.storyboard;
    UINavigationController *nv = (UINavigationController *)self.frostedViewController.contentViewController;
    
    //取消选中
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.row)
    {
        case 0:
        {
            MainViewController *mainVc = [storyBoard instantiateViewControllerWithIdentifier:@"MainViewController"];
            [nv setViewControllers:@[mainVc] animated:YES];
            [self.frostedViewController hideMenuViewControllerWithCompletionHandler:^{
                //TODO
            }];
            break;
        }
        case 1:
        {
            AddBuddyViewController *addBuddyVc = [storyBoard instantiateViewControllerWithIdentifier:@"AddBuddyViewController"];
            [nv setViewControllers:@[addBuddyVc] animated:YES];
            [self.frostedViewController hideMenuViewControllerWithCompletionHandler:^{
                //TODO
            }];
            break;
        }
        case 2:
        {
            AddBillViewController *addBillVc = [storyBoard instantiateViewControllerWithIdentifier:@"AddBillViewController"];
            MainViewController *mainVc = [storyBoard instantiateViewControllerWithIdentifier:@"MainViewController"];
            [nv setViewControllers:@[mainVc,addBillVc] animated:YES];
            
            [self.frostedViewController hideMenuViewControllerWithCompletionHandler:^{
                //TODO
            }];
            break;
        }
        case 3:
        {
            HistoryBillsViewController *hbvc = [storyBoard instantiateViewControllerWithIdentifier:@"HistoryBillsViewController"];
            [nv setViewControllers:@[hbvc] animated:YES];
            [self.frostedViewController hideMenuViewControllerWithCompletionHandler:^{
                //TODO
            }];
            break;
        }
        default:
            break;
    }
}

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end

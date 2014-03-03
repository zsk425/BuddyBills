//
//  HistoryBillsViewController.m
//  BuddyBills
//
//  Created by zhaosk on 14-3-1.
//  Copyright (c) 2014年 zhaosk. All rights reserved.
//

#import "HistoryBillsViewController.h"
@import CoreData;
#import "SDCoreDataController.h"
#import "Bill.h"
#import "DetailBillViewController.h"

@interface HistoryBillsViewController ()<UISearchBarDelegate,UISearchDisplayDelegate>

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@end

@implementation HistoryBillsViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"历史账单";
    
    //UI调整
    self.tableView.backgroundColor = [UIColor cloudsColor];
    // 将搜索栏藏起来（搜索栏只有在用户滚动到列表视图顶端时才会出现）
    CGRect newBounds = self.tableView.bounds;
    newBounds.origin.y = newBounds.origin.y + self.searchDisplayController.searchBar.bounds.size.height;
    self.tableView.bounds = newBounds;
    
    //Menu
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Menu" style:UIBarButtonItemStylePlain target:self action:@selector(showMenu:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(goToSearch:)];

    //配置NSFetchedResultsController
    NSManagedObjectContext *context = [SDCoreDataController sharedInstance].masterManagedObjectContext;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Bill" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"activityDate" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc]
                                              initWithFetchRequest:fetchRequest
                                              managedObjectContext:context
                                              sectionNameKeyPath:nil
                                              cacheName:nil];
    
    NSError *error;
    [self.fetchedResultsController performFetch:&error];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger count = [[self.fetchedResultsController sections] count];
    return count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([[self.fetchedResultsController sections] count] > 0) {
        id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
        return [sectionInfo numberOfObjects];
    } else
        return 0;}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    Bill *bill = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    cell.textLabel.text = bill.activityName;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    cell.detailTextLabel.text = [formatter stringFromDate:bill.activityDate];
    
    //调整UI
    [cell configureFlatCellWithColor:[UIColor greenSeaColor] selectedColor:[UIColor cloudsColor]];
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if ([[self.fetchedResultsController sections] count] > 0) {
        id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
        return [sectionInfo name];
    } else
        return nil;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return [self.fetchedResultsController sectionIndexTitles];
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    return [self.fetchedResultsController sectionForSectionIndexTitle:title atIndex:index];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //[tableView deselectRowAtIndexPath:indexPath animated:YES];
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

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

#pragma mark - UI Event
- (void)showMenu:(id)sender
{
    REFrostedViewController *vc = (REFrostedViewController *)[[TMCache sharedCache] objectForKey:FROSTEDVIEWCONTROLLER];
    
    [vc presentMenuViewController];
}

-(void)goToSearch:(id)sender {
    // 如果你担心用户无法发现藏在列表顶端的搜索栏，那我们在导航栏加一个搜索图标。
    // 如果你不隐藏搜索栏，那就别加入这个搜索图标，否则就重复了。
    [self.searchDisplayController.searchBar becomeFirstResponder];
}

#pragma mark - segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showDetailBill"])
    {
        DetailBillViewController *dvc = segue.destinationViewController;
        
        // 我们需要知道哪个是现在正显示的列表视图，这样才能从相应的数组中提取正确的信息，显示在详细视图中。
        NSIndexPath *indexPath = nil;
        if (self.searchDisplayController.active)
        {
            indexPath = [self.searchDisplayController.searchResultsTableView indexPathForSelectedRow];
            NSLog(@"1");
        }
        else
        {
            indexPath = [self.tableView indexPathForSelectedRow];
        }
        dvc.bill = [self.fetchedResultsController objectAtIndexPath:indexPath];
    }
}

#pragma mark - UISearchDisplayController Delegate Methods
- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat: @"ANY buddyBills.buddy.name CONTAINS \"%@\"",searchText] ];
    [self.fetchedResultsController.fetchRequest setPredicate:predicate];
    NSError *error;
    [self.fetchedResultsController performFetch:&error];
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    // 当用户改变搜索字符串时，让列表的数据来源重新加载数据
    [self filterContentForSearchText:searchString scope:nil];
    // 返回YES，让table view重新加载。
    return YES;
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption {
    // 当用户改变搜索范围时，让列表的数据来源重新加载数据
    [self filterContentForSearchText:controller.searchBar.text scope:nil];
    // 返回YES，让table view重新加载。
    return YES;
}

/*
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    // 当用户改变搜索字符串时，让列表的数据来源重新加载数据
    self.predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat: @"ALL buddyBills.buddy.name == %@",searchBar.text] ];
    [self.fetchRequest setPredicate:self.predicate];
    NSError *error;
    [self.fetchedResultsController performFetch:&error];
}
 */
//- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText;   // called when text changes (including clear)


@end

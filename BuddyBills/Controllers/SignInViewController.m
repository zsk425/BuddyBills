//
//  SignInViewController.m
//  BuddyBills
//
//  Created by zhaosk on 14-2-21.
//  Copyright (c) 2014年 zhaosk. All rights reserved.
//

#import "SignInViewController.h"
#import <FlatUIKit/FlatUIKit.h>
#import <Parse/Parse.h>
#import <TSMessages/TSMessageView.h>
#import "MenuViewController.h"

@interface SignInViewController () <UITableViewDataSource, UITableViewDelegate>
{
    UITextField *_username;
    UITextField *_password;
}

@property (weak, nonatomic) IBOutlet FUIButton *signUp;
@property (weak, nonatomic) IBOutlet FUIButton *signIn;

@end

@implementation SignInViewController

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
    
    [self.view addSubview:({
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 150, 320, 88) style:UITableViewStylePlain];
        tableView.scrollEnabled = NO;
        tableView.separatorColor = [UIColor greenSeaColor];
        tableView.separatorInset = UIEdgeInsetsMake(0, 90, 0, 50);
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView;
    })];
    
    _username = [[UITextField alloc] initWithFrame:CGRectZero];
    _username.text = @"zsk425";
    _username.placeholder = @"username@me.com";
    _password = [[UITextField alloc] initWithFrame:CGRectZero];
    _password.placeholder = @"password";
    [_password setSecureTextEntry:YES];
    
    [self.view addSubview:({
        _signUp.buttonColor = [UIColor turquoiseColor];
        _signUp.shadowColor = [UIColor greenSeaColor];
        _signUp.shadowHeight = 3.0f;
        _signUp.cornerRadius = 6.0f;
        _signUp.titleLabel.font = [UIFont boldFlatFontOfSize:16];
        [_signUp setTitleColor:[UIColor cloudsColor] forState:UIControlStateNormal];
        [_signUp setTitleColor:[UIColor cloudsColor] forState:UIControlStateHighlighted];
        _signUp;
    })];
    
    [self.view addSubview:({
        _signIn.buttonColor = [UIColor turquoiseColor];
        _signIn.shadowColor = [UIColor greenSeaColor];
        _signIn.shadowHeight = 3.0f;
        _signIn.cornerRadius = 6.0f;
        _signIn.titleLabel.font = [UIFont boldFlatFontOfSize:16];
        [_signIn setTitleColor:[UIColor cloudsColor] forState:UIControlStateNormal];
        [_signIn setTitleColor:[UIColor cloudsColor] forState:UIControlStateHighlighted];
        _signIn;
    })];
    
    //添加手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self.view addGestureRecognizer:tap];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *indentifier = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if (0 == indexPath.row)
    {
        [cell.contentView addSubview:({
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, 60, 44)];
            label.textColor = [UIColor colorWithWhite:0.2 alpha:0.8];
            label.text = @"账号";
            label;
        })];
        
        _username.frame = CGRectMake(100, 0, 200, 44);
        [cell.contentView addSubview:_username];
    }
    else
    {
        [cell.contentView addSubview:({
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, 60, 44)];
            label.textColor = [UIColor colorWithWhite:0.2 alpha:0.8];
            label.text = @"密码";
            label;
        })];
        
        _password.frame = CGRectMake(100, 0, 200, 44);
        [cell.contentView addSubview:_password];
    }
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    return 1;
}

#pragma mark - UITableView delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0;
}


#pragma mark - UI Event
- (void)handleTap:(UITapGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateEnded)
    {
        [self.view endEditing:YES];
    }
}

- (IBAction)signUp:(id)sender
{
    [self.view endEditing:YES];
    
    if (_username.text.length < 6 || _username.text.length > 20)
    {
        [TSMessage showNotificationInViewController:self title:@"用户名太短或太长" subtitle:@"" type:TSMessageNotificationTypeError];
        return;
    }
    else if(_password.text.length < 6 || _password.text.length > 15)
    {
        [TSMessage showNotificationInViewController:self title:@"用户名太短或太长" subtitle:@"" type:TSMessageNotificationTypeError];
        return;
    }
    
    PFUser *user = [PFUser user];
    user.username = _username.text;
    user.password = _password.text;
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            // Hooray! Let them use the app now.
            [TSMessage showNotificationInViewController:self title:@"注册成功" subtitle:@"" type:TSMessageNotificationTypeSuccess];
        } else {
            NSString *errorString = [error userInfo][@"error"];
            [TSMessage showNotificationInViewController:self title:@"注册失败" subtitle:errorString type:TSMessageNotificationTypeError];
        }
    }];
}

- (IBAction)signIn:(id)sender
{
    [self.view endEditing:YES];
    
    if (_username.text.length < 6 || _username.text.length > 20)
    {
        [TSMessage showNotificationInViewController:self title:@"用户名太短或太长" subtitle:@"" type:TSMessageNotificationTypeError];
        return;
    }
    else if(_password.text.length < 6 || _password.text.length > 15)
    {
        [TSMessage showNotificationInViewController:self title:@"用户名太短或太长" subtitle:@"" type:TSMessageNotificationTypeError];
        return;
    }
    
    [PFUser logInWithUsernameInBackground:_username.text password:_password.text
                                    block:^(PFUser *user, NSError *error) {
                                        if (user) {
                                            
                                            //跳转到新页面
                                            UIStoryboard *storyBoard = self.storyboard;
                                            // Create content and menu controllers
                                            //
#if 1
                                            UINavigationController *navigationController = [storyBoard instantiateViewControllerWithIdentifier:@"MainNavigationViewController"];
#else
                                            UINavigationController *navigationController = [[UINavigationController alloc] init];
#endif
                                            MenuViewController *menuController = [storyBoard instantiateViewControllerWithIdentifier:@"MenuViewController"];
                                            
                                            // Create frosted view controller
                                            //
                                            REFrostedViewController *frostedViewController = [[REFrostedViewController alloc] initWithContentViewController:navigationController menuViewController:menuController];
                                            frostedViewController.direction = REFrostedViewControllerDirectionLeft;
                                            
                                            // Make it a root controller
                                            [self presentViewController:frostedViewController animated:YES completion:^{
                                                [[TMCache sharedCache] setObject:frostedViewController forKey:FROSTEDVIEWCONTROLLER];
                                            }];
                                        } else {
                                            NSString *errorString = [error userInfo][@"error"];
                                            [TSMessage showNotificationInViewController:self title:@"登陆失败" subtitle:errorString type:TSMessageNotificationTypeError];
                                        }
                                    }];
}

@end

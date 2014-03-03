//
//  AppDelegate.m
//  BuddyBills
//
//  Created by zhaosk on 14-2-21.
//  Copyright (c) 2014年 zhaosk. All rights reserved.
//

#import "AppDelegate.h"
#import <Parse/Parse.h>
#import <TSMessages/TSMessageView.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    [Parse setApplicationId:@"aJo2oEH7QAum6RZ2Xi9NIOhIkc2UMgjTcQ1sNAY7"
                  clientKey:@"smKl9DlgNR01omPaRiQAXia1hNbqs7rlBUzipWEM"];
    
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    //TSMessage
    [TSMessage setDefaultViewController: self.window.rootViewController];
    
    //UI
    self.window.tintColor = [UIColor greenSeaColor];
    [[UINavigationBar appearance] setTintColor:[UIColor greenSeaColor]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{
                                                           NSForegroundColorAttributeName:[UIColor greenSeaColor],
                                                           }];
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end

//
//  POAppDelegate.m
//  The Pomodoro
//
//  Created by Joshua Howland on 6/3/14.
//  Copyright (c) 2014 DevMountain. All rights reserved.
//

#import "POAppDelegate.h"
#import "POHistoryViewController.h"
#import "POTimerViewController.h"

@implementation POAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    POTimerViewController *timerViewController = [POTimerViewController new];
    timerViewController.tabBarItem.title = @"Timer";
    timerViewController.tabBarItem.image = [UIImage imageNamed:@"tomatos"];
    UINavigationController *timerNav = [[UINavigationController alloc] initWithRootViewController:timerViewController];
    
    POHistoryViewController *historyViewController = [POHistoryViewController new];
    historyViewController.tabBarItem.title = @"Rounds";
    historyViewController.tabBarItem.image = [UIImage imageNamed:@"list"];
    UINavigationController *historyNav = [[UINavigationController alloc]initWithRootViewController:historyViewController];
    
    UITabBarController *tabBarController = [UITabBarController new];
    tabBarController.viewControllers = @[timerNav, historyNav];
    tabBarController.view.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = tabBarController;
    
    [[UINavigationBar appearance]setBarTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{
                                                           NSForegroundColorAttributeName:[UIColor blackColor],
                                                           NSFontAttributeName:[UIFont fontWithName:@"Avenir-Light" size:24]
                                                           
                                                           }];
    [[UITabBar appearance]setBarTintColor:[UIColor whiteColor]];
    
    UILocalNotification *locationNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    if (locationNotification) {
        // Set icon badge number to zero
        application.applicationIconBadgeNumber = 0;
    }

    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    application.applicationIconBadgeNumber = 0;
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
    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)]){ //iOS8
        
        [application registerUserNotificationSettings:
         [UIUserNotificationSettings settingsForTypes:(UIRemoteNotificationTypeBadge |
                                                       UIRemoteNotificationTypeSound |
                                                       UIRemoteNotificationTypeAlert)
                                           categories:nil]];
        [application registerForRemoteNotifications];
        
    } else {
        
        [application registerForRemoteNotificationTypes:(UIRemoteNotificationType)
         (UIRemoteNotificationTypeBadge |
          UIRemoteNotificationTypeSound |
          UIRemoteNotificationTypeAlert)];
        
    }
// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end

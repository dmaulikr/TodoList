//
//  TLAppDelegate.m
//  Tasklist
//
//  Created by Jiangz on 12/10/13.
//  Copyright (c) 2013 devmania. All rights reserved.
//

#import "TLAppDelegate.h"
#import "LLTask.h"
#import "TLViewController.h"
#import "TLDetailTaskViewController.h"

@implementation TLAppDelegate

- (void)dealloc
{
    [_window release];
    [_viewController release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSLog(@"application didFinishLaunchingWithOptions");
    
//    #ifdef LITE
//        NSLog(@"lite version");
//    #else
//        NSLog(@"paid version");
//    #endif
    
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    self.viewController = [[[TLViewController alloc] initWithNibName:@"TLViewController" bundle:nil] autorelease];
    self.viewController.displayOption = TLTodayTasks;
    self.rootNavController = [[[UINavigationController alloc] initWithRootViewController:self.viewController] autorelease];
    self.window.rootViewController = self.rootNavController;
    [self.window makeKeyAndVisible];
    return YES;
}

-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    NSLog(@"received notification: alarm");
    NSString *taskid = [notification.userInfo objectForKey:@"taskid"];
    
    NSArray *allTaskList = [[NSUserDefaults standardUserDefaults] objectForKey:TASKLIST_OBJECT_KEY];
    
    for (NSDictionary *dictionary in allTaskList) {
        if ([dictionary[TASK_TITLEID] isEqualToString:taskid]) {
            
            LLTask *taskObject = [[LLTask alloc] initWithData:dictionary];
            NSLog(@"%@", taskObject.title);
            [self.rootNavController popToRootViewControllerAnimated:NO];
            
            TLDetailTaskViewController *subvc = [[TLDetailTaskViewController alloc] init];
            subvc.delegate = self.viewController;
            subvc.taskObject = taskObject;
            subvc.strDateFormat = self.viewController.strDateFormat;
            subvc.strTimeFormat = self.viewController.strTimeFormat;
            
            UIApplication *app = [UIApplication sharedApplication];
//            NSInteger badgeNumber = [app applicationIconBadgeNumber];// Take the current badge number
//            badgeNumber--;    // decrement by one
            [app setApplicationIconBadgeNumber:0];
            [app cancelLocalNotification:taskObject.notification];
            [self.rootNavController pushViewController:subvc animated:NO];
        }
    }
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

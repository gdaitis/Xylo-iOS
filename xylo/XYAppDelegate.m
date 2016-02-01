//
//  XYAppDelegate.m
//  xylo
//
//  Created by Lukas Kekys on 2/24/14.
//  Copyright (c) 2014 Seriously. All rights reserved.
//

#import "XYAppDelegate.h"
#import "XYUtils.h"
#import "XYRootViewController.h"
#import "XYNewPasswordViewController.h"

#import <Crashlytics/Crashlytics.h>
//#define kCrashlyticsAPIKey @"7a23b83bede1369e3fa8035c5a5c668549ce2fa7"


@implementation XYAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //checks for data migration, and setups suitable stack
#warning check for changed datamodel and logout currentUser (delete old data?)
    [MagicalRecord setupAutoMigratingCoreDataStack];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    XYRootViewController *rootViewController = [[XYRootViewController alloc] init];
    self.window.rootViewController = rootViewController;
    
    [self.window makeKeyAndVisible];
    
    //must be after al 3rd party sdk code
    //[Crashlytics startWithAPIKey:kCrashlyticsAPIKey];
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    NSLog(@"Calling Application Bundle ID: %@", sourceApplication);
    NSLog(@"URL scheme:%@", [url scheme]);
    NSLog(@"URL query: %@", [url query]);
    
    NSString *token = [[url query] stringByReplacingOccurrencesOfString:@"token=" withString:@""];
    NSNotification *notification = [[NSNotification alloc] initWithName:XYPasswordResetViewControllerTokenNotification
                                                                 object:nil
                                                               userInfo:@{@"token": token}];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
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
    
    [MagicalRecord saveWithBlock:nil];
}

@end

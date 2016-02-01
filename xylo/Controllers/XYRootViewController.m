//
//  XYRootViewController.m
//  xylo
//
//  Created by lite on 09/04/14.
//  Copyright (c) 2014 Seriously. All rights reserved.
//

#import "XYRootViewController.h"
#import "MMDrawerController+Subclass.h"
#import "XYLeftMenuViewController.h"
#import "XYActivityFeedViewController.h"
#import "XYLoggedInNavigationViewController.h"
#import "XYLoginService.h"
#import "XYAPIClient.h"
#import "XYEnterCodeViewController.h"
#import "XYLoginViewController.h"

const double kXYRootViewControllerWidthOfLeftMenuNormal = 287.0f;

@interface XYRootViewController () <XYLoginViewControllerDelegate>

@end

@implementation XYRootViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        XYLeftMenuViewController *leftMenuViewController = [[XYLeftMenuViewController alloc] init];
        XYActivityFeedViewController *activityFeedViewController = [[XYActivityFeedViewController alloc] init];
        XYLoggedInNavigationViewController *navigationController = [[XYLoggedInNavigationViewController alloc] initWithRootViewController:activityFeedViewController];
        
        self.leftDrawerViewController = leftMenuViewController;
        self.centerViewController = navigationController;
        [self setShowsShadow:YES];
        
        [self setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
        [self setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(logoutNotificationReceived)
                                                     name:kXYAPIClientLogoutNotificationName
                                                   object:nil];
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if ([XYAPIClient sharedClient].loggedOut)
        [self showLoginViewController];
}

- (void)logoutNotificationReceived
{
    [self showLoginViewController];
}

- (void)showLoginViewController
{
    XYLoginViewController *loginController = [[XYLoginViewController alloc] initWithNibName:@"XYLoginViewController" bundle:[NSBundle mainBundle]];
    loginController.delegate = self;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:loginController];
    [self presentViewController:navigationController animated:NO completion:nil];
}

- (void)loginViewControllerDidLogIn:(XYLoginViewController *)loginViewController
{
    [self dismissViewControllerAnimated:NO completion:nil];
    XYActivityFeedViewController *activityFeedViewController = [[XYActivityFeedViewController alloc] init];
    XYLoggedInNavigationViewController *navigationController = [[XYLoggedInNavigationViewController alloc] initWithRootViewController:activityFeedViewController];
    [self setCenterViewController:navigationController];
}


//- (void)showLoginViewController
//{
//    XYEnterCodeViewController *enterCodeViewController = [[XYEnterCodeViewController alloc] init];
//    enterCodeViewController.delegate = self;
//    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:enterCodeViewController];
//    [self presentViewController:navigationController animated:NO completion:nil];
//}
//
//- (void)enterCodeViewControllerDidLogIn:(XYEnterCodeViewController *)enterCodeViewController
//{
//    [self dismissViewControllerAnimated:NO completion:nil];
//    XYActivityFeedViewController *activityFeedViewController = [[XYActivityFeedViewController alloc] init];
//    XYLoggedInNavigationViewController *navigationController = [[XYLoggedInNavigationViewController alloc] initWithRootViewController:activityFeedViewController];
//    [self setCenterViewController:navigationController];
//}

@end

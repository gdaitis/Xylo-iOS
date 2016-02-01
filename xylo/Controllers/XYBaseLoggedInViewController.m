//
//  XYBaseLoggedInViewController.m
//  xylo
//
//  Created by lite on 02/07/14.
//  Copyright (c) 2014 Seriously. All rights reserved.
//

#import "XYBaseLoggedInViewController.h"
#import <MMDrawerController/UIViewController+MMDrawerController.h>
#import "XYLeftMenuViewController.h"
#import "XYNavigationBarBackButton.h"
#import "UIView+NibLoading.h"

@implementation XYBaseLoggedInViewController

- (void)enableCustomNavigationBar
{
    
    // container
    UIView *container = [[UIView alloc] init]; // <- why don't we make this a singleton so we could access it from anywhere?
    container.frame = CGRectMake(0, 0, 304, 44);
    container.backgroundColor = [UIColor clearColor];
    [self.navigationItem setTitleView:container];
    
    // left menu
    UIImage *menuImage = ([self.navigationController.viewControllers count] > 1) ? [UIImage imageNamed:@"BackButton"] : [UIImage imageNamed:@"navigationBarLeftButton"];
    UIButton *menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    menuButton.translatesAutoresizingMaskIntoConstraints = NO;
    menuButton.contentMode = UIViewContentModeScaleAspectFit;
    [menuButton setImage:menuImage forState:UIControlStateNormal];
    [menuButton addTarget:self action:@selector(leftButtonSelected) forControlEvents:UIControlEventTouchUpInside];
    [container addSubview:menuButton];
    
    [menuButton autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [menuButton autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:3];
    [menuButton autoSetDimensionsToSize:menuImage.size];
    
    // settings
    UIImage *settingsImage = [UIImage imageNamed:@"navigationBarSettingsButton"];
    UIButton *settingsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    settingsButton.translatesAutoresizingMaskIntoConstraints = NO;
    settingsButton.contentMode = UIViewContentModeScaleAspectFit;
    [settingsButton setImage:settingsImage forState:UIControlStateNormal];
    [settingsButton addTarget:self action:@selector(settingsPressed) forControlEvents:UIControlEventTouchUpInside];
    [container addSubview:settingsButton];
    
    [settingsButton autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [settingsButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:3];
    [settingsButton autoSetDimensionsToSize:settingsImage.size];
    
    // chat
    UIImage *chatImage = [UIImage imageNamed:@"navigationBarChatButton"];
    UIButton *chatButton = [UIButton buttonWithType:UIButtonTypeCustom];
    chatButton.translatesAutoresizingMaskIntoConstraints = NO;
    chatButton.contentMode = UIViewContentModeScaleAspectFit;
    [chatButton setImage:chatImage forState:UIControlStateNormal];
    [chatButton addTarget:self action:@selector(chatPressed) forControlEvents:UIControlEventTouchUpInside];
    [container addSubview:chatButton];
    
    [chatButton autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [chatButton autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:settingsButton withOffset:-22];
    [chatButton autoSetDimensionsToSize:chatImage.size];
    
    // notifications
    UIImage *notificationsImage = [UIImage imageNamed:@"navigationBarNotificationsButton"];
    UIButton *notificationsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    notificationsButton.translatesAutoresizingMaskIntoConstraints = NO;
    notificationsButton.contentMode = UIViewContentModeScaleAspectFit;
    [notificationsButton setImage:notificationsImage forState:UIControlStateNormal];
    [notificationsButton addTarget:self action:@selector(notificationsPressed) forControlEvents:UIControlEventTouchUpInside];
    [container addSubview:notificationsButton];
    
    [notificationsButton autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [notificationsButton autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:chatButton withOffset:-22];
    [notificationsButton autoSetDimensionsToSize:notificationsImage.size];
    
    // title
    UILabel *titleLabel = [UILabel newAutoLayoutView];
    titleLabel.font = [UIFont fontWithName:@"OpenSans" size:19];
    titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    titleLabel.numberOfLines = 1;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = self.title;
    [container addSubview:titleLabel];
    
    [titleLabel autoAlignAxis:ALAxisHorizontal toSameAxisOfView:container withOffset:-1];
    [titleLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:menuButton withOffset:8];
    [titleLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:notificationsButton withOffset:-8];
}

- (void)leftButtonSelected
{
    if ([self.navigationController.viewControllers count] > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else {
        [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
        
        if ([self.mm_drawerController.leftDrawerViewController isKindOfClass:[XYLeftMenuViewController class]])
            [(XYLeftMenuViewController *)self.mm_drawerController.leftDrawerViewController updateOrganizationlistModel];
    }
}

- (void)settingsPressed
{
    
}

- (void)chatPressed
{
    
}

- (void)notificationsPressed
{
    
}

#pragma mark - Back button

-(void)showBackButton
{
    XYNavigationBarBackButton *navigationBarBackButton = (XYNavigationBarBackButton *)[XYNavigationBarBackButton loadInstanceFromNib];
    [navigationBarBackButton.backButton addTarget:self action:@selector(backButtonSelected) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spacer.width = -5;
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:navigationBarBackButton];
    self.navigationItem.leftBarButtonItems = @[spacer, backItem];
}

- (void)backButtonSelected
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end

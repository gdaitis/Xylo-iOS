//
//  XYActivityFeedViewController.m
//  xylo
//
//  Created by lite on 09/04/14.
//  Copyright (c) 2014 Seriously. All rights reserved.
//

#import "XYActivityFeedViewController.h"
#import "XYEnterCodeViewController.h"

@interface XYActivityFeedViewController ()

@property (nonatomic, weak) IBOutlet UILabel *textLabel;

@end

@implementation XYActivityFeedViewController

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
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"Very";
    [self enableCustomNavigationBar];
    
    self.textLabel.text = @"Thanks for registering for the Xylo beta. You can get started using personal Xylo features, such as Calendar and Tasks. To complete your profile, simply click on your name and select Edit.\n\nTo get connected with your school or organization, simply search by name from the search bar, then select Join. If your school or organization has not yet been claimed and you are its authorized representative, select Claim.\n\nUsers may also send private messages to other users by clicking on the messaging icon in the top navigation bar, select New Message, then entering the user’s name into the Send to field. User may only send private messages to other users who are also members of the same school or organization.\n\nIf you have any questions or issues with the Xylo service, please click on the Support link in the site footer.\n\nThanks for joining,\n\nXylo Team";
}

@end

//
//  XYBaseProfilePageController.m
//  xylo
//
//  Created by Lukas Kekys on 08/04/14.
//  Copyright (c) 2014 Seriously. All rights reserved.
//

#import "XYBaseProfilePageController.h"

@interface XYBaseProfilePageController () <UITableViewDataSource,UITableViewDelegate>

@end

@implementation XYBaseProfilePageController

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
	// Do any additional setup after loading the view.
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorInset = UIEdgeInsetsZero;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

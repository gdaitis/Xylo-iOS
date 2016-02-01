//
//  XYOrganizationsListModel.m
//  xylo
//
//  Created by Lukas Kekys on 02/07/14.
//  Copyright (c) 2014 Seriously. All rights reserved.
//

#import "XYOrganizationsListModel.h"
#import "XYOrganization+OrganizationFunctions.h"
#import "XYOrganizationService.h"

NSString * const XYLeftMenuViewControllerListUpdateDate = @"XYLeftMenuViewControllerListUpdateDate";

@implementation XYOrganizationsListModel

- (id)init
{
    self = [super init];
    if (self) {
        [self setupListModel];
    }
    return self;
}

- (void)setupListModel
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadOrganizations) name:kOrganizationListUpdatedNotification object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kOrganizationListUpdatedNotification object:nil];
}


- (void)loadOrganizations
{
    NSArray *organizationArray = [XYOrganization masterUserOrganizations];
    self.organizations = organizationArray;
    
    [self organizationsUpdated];
}

- (void)organizationsUpdated
{
    [self.delegate organizationListChanged:self];
}

- (void)updateListModelIfNeeded
{
#warning should also add manual tableview reload (drag reload to update organization list)
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSDate *lastUpdated = [userDefaults objectForKey:XYLeftMenuViewControllerListUpdateDate];
    
    if (lastUpdated != nil) {
        
        int timeDifference = [[NSDate date] timeIntervalSinceDate:lastUpdated];
        if (timeDifference < 300) {
            return;
        }
        else {
            [self downloadOrganizationInfo];
        }
    }
}

- (void)downloadOrganizationInfo
{
    [XYOrganizationService getMasterUserOrganizationsSuccessBlock:^ {
        [self organizationsUpdated];
    } failureBlock:^(XYOrganizationServiceCodeCheckError codeCheckError){
        
    }];
}

@end

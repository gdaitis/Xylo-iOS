//
//  XYOrganization+OrganizationFunctions.h
//  xylo
//
//  Created by Lukas Kekys on 28/04/14.
//  Copyright (c) 2014 Seriously. All rights reserved.
//

#import "XYOrganization.h"

@interface XYOrganization (OrganizationFunctions)

+ (XYOrganization *)updateOrganizationFromResponse:(id)response;
+ (void)updateOrganizationsFromResponse:(id)response;
+ (NSArray *)masterUserOrganizations;


- (NSArray *)ensemblesSortedByName;

@end

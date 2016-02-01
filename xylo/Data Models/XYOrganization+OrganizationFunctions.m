//
//  XYOrganization+OrganizationFunctions.m
//  xylo
//
//  Created by Lukas Kekys on 28/04/14.
//  Copyright (c) 2014 Seriously. All rights reserved.
//

#import "XYOrganization+OrganizationFunctions.h"
#import "XYUser+UserFunctions.h"
#import "NSDictionary+NullConverver.h"

@implementation XYOrganization (OrganizationFunctions)

+ (XYOrganization *)updateOrganizationFromResponse:(id)response
{
    XYOrganization *organization = nil;
    if ([response isKindOfClass:[NSDictionary class]]) {
        
        NSManagedObjectContext *context = [NSManagedObjectContext MR_defaultContext];
        NSDictionary *dictionaryWithoutNulls = [response dictionaryByReplacingNullsWithStrings];
        organization = [self updateOrganizationFromDictionary:dictionaryWithoutNulls inContext:context];
        [context MR_saveOnlySelfAndWait];
    }
    
    return organization;
}

+ (XYOrganization *)updateOrganizationFromDictionary:(NSDictionary *)organizationDictionary inContext:(NSManagedObjectContext *)context
{
    NSNumber *organizationID = [NSNumber numberWithInt:[[organizationDictionary valueForKey:@"Id"] intValue]];
    XYOrganization *organization = [XYOrganization MR_findFirstByAttribute:@"organizationID" withValue:organizationID inContext:context];
    if (!organization) {
        organization = [XYOrganization MR_createInContext:context];
        organization.organizationID = organizationID;
    }
    organization.coverImageUrl = [organizationDictionary valueForKey:@"CoverImageUrl"];
    organization.facebook = [organizationDictionary valueForKey:@"Facebook"];
    organization.firstAddress = [organizationDictionary valueForKey:@"FirstAddress"];
    organization.instagram = [organizationDictionary valueForKey:@"Instagram"];
    organization.logoImageUrl = [organizationDictionary valueForKey:@"LogoImageUrl"];
    organization.name = [organizationDictionary valueForKey:@"Name"];
    organization.phone = [organizationDictionary valueForKey:@"Phone"];
    organization.soundcloud = [organizationDictionary valueForKey:@"Soundcloud"];
    organization.twitter = [organizationDictionary valueForKey:@"Twitter"];
    organization.website = [organizationDictionary valueForKey:@"Website"];
    organization.youtube = [organizationDictionary valueForKey:@"YouTube"];
    organization.boosters = [organizationDictionary valueForKey:@"Boosters"];
    organization.director = [organizationDictionary valueForKey:@"Director"];
    organization.users = nil;
    
    NSMutableSet *userSet = [[NSMutableSet alloc] init];
    //parse and add users to organization
    NSArray *userArray = [organizationDictionary valueForKey:@"Members"];
    for (NSDictionary *userDict in userArray) {
        
        NSDictionary *userDictionary = [userDict dictionaryByReplacingNullsWithStrings];
        XYUser *user = [XYUser updateUserFromResponse:userDictionary];
        
        [userSet addObject:user];
    }
    organization.users = userSet;
    
    return organization;
}

+ (void)updateOrganizationsFromResponse:(id)response
{
    if ([response isKindOfClass:[NSArray class]]) {
        
        NSManagedObjectContext *context = [NSManagedObjectContext MR_defaultContext];
        for (NSDictionary *organizationDict in response) {
            
            NSDictionary *organizationDictionary = [organizationDict dictionaryByReplacingNullsWithStrings];
            [self updateOrganizationFromDictionary:organizationDictionary inContext:context];
        }
        [context MR_saveOnlySelfAndWait];
    }
    else
        return;
}

+ (NSArray *)masterUserOrganizations
{
    XYUser *masterUser = [XYUser masterUser];
    NSPredicate *userPredicate = [NSPredicate predicateWithFormat:@"ANY users == %@",masterUser];
    NSArray *resultArray = [XYOrganization MR_findAllSortedBy:@"name" ascending:YES withPredicate:userPredicate inContext:[NSManagedObjectContext MR_defaultContext]];
    
    return resultArray;
}

- (NSArray *)ensemblesSortedByName
{
    NSSortDescriptor *nameAlphabeticSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    NSArray *sortedEnsembles = [self.ensembles sortedArrayUsingDescriptors:@[nameAlphabeticSortDescriptor]];
    
    return sortedEnsembles;
}

@end

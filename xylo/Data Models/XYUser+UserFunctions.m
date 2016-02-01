//
//  XYUser+UserFunctions.m
//  xylo
//
//  Created by Lukas Kekys on 07/05/14.
//  Copyright (c) 2014 Seriously. All rights reserved.
//

#import "XYUser+UserFunctions.h"
#import "NSDictionary+NullConverver.h"
#import "XYEnsemble.h"

@implementation XYUser (UserFunctions)

+ (XYUser *)updateUserFromResponse:(id)response
{
    XYUser *user = nil;
    if ([response isKindOfClass:[NSDictionary class]]) {
        
        NSDictionary *formatedResponse = [response dictionaryByReplacingNullsWithStrings];
        
        NSManagedObjectContext *context = [NSManagedObjectContext MR_defaultContext];
        
        user = [XYUser MR_findFirstByAttribute:@"userID" withValue:formatedResponse[@"Id"]];
        if (!user) {
            user = [XYUser MR_createInContext:context];
            user.userID = formatedResponse[@"Id"];
        }
        user.username = formatedResponse[@"UserName"];
        user.email = formatedResponse[@"Email"];
        user.firstName = formatedResponse[@"FirstName"];
        user.fullName = formatedResponse[@"FullName"];
        user.telephone = formatedResponse[@"Tel"];
        user.lastName = formatedResponse[@"LastName"];
        
        user.bio = formatedResponse[@"Bio"];
        user.coverImageUrl = formatedResponse[@"CoverImageUrl"];
        user.firstAddress = formatedResponse[@"FirstAddress"];
        user.logoImageUrl = formatedResponse[@"LogoImageUrl"];
        user.mobilePhone = formatedResponse[@"MobileTel"];
        
        
        [context MR_saveToPersistentStoreAndWait];
    }
    return user;
}

+ (XYUser *)masterUser
{
    NSManagedObjectContext *context = [NSManagedObjectContext MR_defaultContext];
    NSString *username = [[NSUserDefaults standardUserDefaults] valueForKey:@"username"];
    XYUser *user = [XYUser MR_findFirstByAttribute:@"username" withValue:username inContext:context];
    
    return user;
}

+ (XYUser *)masterUserInContext:(NSManagedObjectContext *)context
{
    NSString *username = [[NSUserDefaults standardUserDefaults] valueForKey:@"username"];
    XYUser *user = [XYUser MR_findFirstByAttribute:@"username" withValue:username inContext:context];
    
    return user;
}

+ (BOOL)masterUserBelongsToEnsemble:(XYEnsemble *)ensemble
{
    XYUser *masterUser = [self masterUser];
    
    NSPredicate *userPredicate = [NSPredicate predicateWithFormat:@"self == %@",masterUser];
    NSSet *filteredSet = [ensemble.users filteredSetUsingPredicate:userPredicate];
    
    BOOL masterBelongsToEnsemble = ([filteredSet count] > 0) ? YES : NO;
    
    return masterBelongsToEnsemble;
    
//    NSPredicate *userPredicate = [NSPredicate predicateWithFormat:@"ANY users == %@",masterUser]
}

@end

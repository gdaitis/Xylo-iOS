//
//  XYEnsemble+EnsembleFunctions.m
//  xylo
//
//  Created by Lukas Kekys on 28/04/14.
//  Copyright (c) 2014 Seriously. All rights reserved.
//

#import "XYEnsemble+EnsembleFunctions.h"
#import "NSDictionary+NullConverver.h"
#import "XYOrganization.h"
#import "XYUser+UserFunctions.h"
#import "XYEnsembleType.h"

@implementation XYEnsemble (EnsembleFunctions)


#warning change to this after MR update to 2.3 or later
//+ (void)updateEnsemblesFromResponse:(id)response
//{
//    if ([response isKindOfClass:[NSArray class]]) {
//
//        if ([response count] > 0) {
//
//            NSManagedObjectContext *context = [NSManagedObjectContext MR_context];
//            NSArray *ensembles = [XYEnsemble MR_importFromArray:response inContext:context];
//            NSLog(@"ensembles = %@",ensembles);
//        }
//    }
//}


+ (void)updateEnsemblesFromResponse:(id)response
                    forOrganization:(XYOrganization *)parentOrganization
                          inContext:(NSManagedObjectContext *)context
{
    if ([response isKindOfClass:[NSArray class]]) {
        
        NSMutableSet *ensembleSet = [[NSMutableSet alloc] init];
        for (NSDictionary *dataDictionary in response) {
            
            NSDictionary *ensembleDictionary = [dataDictionary dictionaryByReplacingNullsWithStrings];
            
            NSNumber *ensembleID = [NSNumber numberWithInt:[[ensembleDictionary valueForKey:@"Id"] intValue]];
            XYEnsemble *ensemble = [XYEnsemble MR_findFirstByAttribute:@"ensembleID" withValue:ensembleID inContext:context];
            if (!ensemble) {
                ensemble = [XYEnsemble MR_createInContext:context];
                ensemble.ensembleID = ensembleID;
            }
            ensemble.coverImageUrl = [ensembleDictionary valueForKey:@"CoverImageUrl"];
            ensemble.facebook = [ensembleDictionary valueForKey:@"Facebook"];
            //        ensemble.firstAddress = [ensembleDictionary valueForKey:@"FirstAddress"];
            ensemble.instagram = [ensembleDictionary valueForKey:@"Instagram"];
            ensemble.logoImageUrl = [ensembleDictionary valueForKey:@"LogoImageUrl"];
            ensemble.name = [ensembleDictionary valueForKey:@"Name"];
            ensemble.phone = [ensembleDictionary valueForKey:@"Phone"];
            //        ensemble.soundcloud = [ensembleDictionary valueForKey:@"Soundcloud"];
            ensemble.twitter = [ensembleDictionary valueForKey:@"Twitter"];
            ensemble.website = [ensembleDictionary valueForKey:@"Website"];
            ensemble.youtube = [ensembleDictionary valueForKey:@"YouTube"];
            //        ensemble.boosters = [ensembleDictionary valueForKey:@"Boosters"];
            
            //parse ensemble type
            if ([ensembleDictionary valueForKey:@"EnsembleType"] && [[ensembleDictionary valueForKey:@"EnsembleType"] isKindOfClass:[NSDictionary class]]) {
                
                NSLog(@"ensemble type = %@",[ensembleDictionary valueForKey:@"EnsembleType"]);
                
                NSDictionary *ensembleTypeDictionary = [[ensembleDictionary valueForKey:@"EnsembleType"] dictionaryByReplacingNullsWithStrings];
                
                if (ensembleTypeDictionary) {
                    ensemble.ensembleType = nil;
                    NSNumber *ensembleTypeId = [NSNumber numberWithInt:[[ensembleTypeDictionary valueForKey:@"Id"] intValue]];
                    XYEnsembleType *ensembleType = [XYEnsembleType MR_findFirstByAttribute:@"ensembleTypeID" withValue:ensembleTypeId inContext:context];
                    if (!ensembleType) {
                        ensembleType = [XYEnsembleType MR_createInContext:context];
                        ensembleType.ensembleTypeID = ensembleTypeId;
                    }
                    ensembleType.ensembleTypeName = [ensembleTypeDictionary valueForKey:@"Name"];
                    
                    ensemble.ensembleType = ensembleType;
                }
            }
            
            ensemble.users = nil;
            
            
            NSMutableSet *userSet = [[NSMutableSet alloc] init];
            //parse and add users to ensemble and organization
            NSArray *userArray = [ensembleDictionary valueForKey:@"Members"];
            for (NSDictionary *userDict in userArray) {
                
                NSDictionary *userDictionary = [userDict dictionaryByReplacingNullsWithStrings];
                XYUser *user = [XYUser updateUserFromResponse:userDictionary];
                
                [userSet addObject:user];
            }
            ensemble.users = userSet;
            
            [ensembleSet addObject:ensemble];
            [parentOrganization addUsers:userSet];
        }
        parentOrganization.ensembles = ensembleSet;
    }
}

- (NSArray *)usersSortedByName
{
    NSSortDescriptor *nameAlphabeticSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"fullName" ascending:YES];
    NSArray *sortedEnsembles = [self.users sortedArrayUsingDescriptors:@[nameAlphabeticSortDescriptor]];
    
    return sortedEnsembles;
}



@end

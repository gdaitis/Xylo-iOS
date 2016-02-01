//
//  XYOrganization.h
//  xylo
//
//  Created by Lukas Kekys on 26/08/14.
//  Copyright (c) 2014 Seriously. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class XYEnsemble, XYUser;

@interface XYOrganization : NSManagedObject

@property (nonatomic, retain) NSString * boosters;
@property (nonatomic, retain) NSString * coverImageUrl;
@property (nonatomic, retain) NSString * director;
@property (nonatomic, retain) NSString * facebook;
@property (nonatomic, retain) NSString * firstAddress;
@property (nonatomic, retain) NSString * instagram;
@property (nonatomic, retain) NSString * logoImageUrl;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * organizationID;
@property (nonatomic, retain) NSString * phone;
@property (nonatomic, retain) NSString * soundcloud;
@property (nonatomic, retain) NSString * twitter;
@property (nonatomic, retain) NSString * website;
@property (nonatomic, retain) NSString * youtube;
@property (nonatomic, retain) NSSet *ensembles;
@property (nonatomic, retain) NSSet *users;
@end

@interface XYOrganization (CoreDataGeneratedAccessors)

- (void)addEnsemblesObject:(XYEnsemble *)value;
- (void)removeEnsemblesObject:(XYEnsemble *)value;
- (void)addEnsembles:(NSSet *)values;
- (void)removeEnsembles:(NSSet *)values;

- (void)addUsersObject:(XYUser *)value;
- (void)removeUsersObject:(XYUser *)value;
- (void)addUsers:(NSSet *)values;
- (void)removeUsers:(NSSet *)values;

@end

//
//  XYUser.h
//  xylo
//
//  Created by Lukas Kekys on 26/08/14.
//  Copyright (c) 2014 Seriously. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class XYEnsemble, XYInstrumentType, XYOrganization, XYPosition;

@interface XYUser : NSManagedObject

@property (nonatomic, retain) NSString * bio;
@property (nonatomic, retain) NSString * coverImageUrl;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * firstAddress;
@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSString * fullName;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSString * logoImageUrl;
@property (nonatomic, retain) NSString * mobilePhone;
@property (nonatomic, retain) NSString * telephone;
@property (nonatomic, retain) NSString * userID;
@property (nonatomic, retain) NSString * username;
@property (nonatomic, retain) NSSet *ensembles;
@property (nonatomic, retain) NSSet *organizations;
@property (nonatomic, retain) NSSet *positions;
@property (nonatomic, retain) NSSet *userPlayedInstrumentTypes;
@property (nonatomic, retain) NSSet *asignedTasks;
@end

@interface XYUser (CoreDataGeneratedAccessors)

- (void)addEnsemblesObject:(XYEnsemble *)value;
- (void)removeEnsemblesObject:(XYEnsemble *)value;
- (void)addEnsembles:(NSSet *)values;
- (void)removeEnsembles:(NSSet *)values;

- (void)addOrganizationsObject:(XYOrganization *)value;
- (void)removeOrganizationsObject:(XYOrganization *)value;
- (void)addOrganizations:(NSSet *)values;
- (void)removeOrganizations:(NSSet *)values;

- (void)addPositionsObject:(XYPosition *)value;
- (void)removePositionsObject:(XYPosition *)value;
- (void)addPositions:(NSSet *)values;
- (void)removePositions:(NSSet *)values;

- (void)addUserPlayedInstrumentTypesObject:(XYInstrumentType *)value;
- (void)removeUserPlayedInstrumentTypesObject:(XYInstrumentType *)value;
- (void)addUserPlayedInstrumentTypes:(NSSet *)values;
- (void)removeUserPlayedInstrumentTypes:(NSSet *)values;

- (void)addAsignedTasksObject:(NSManagedObject *)value;
- (void)removeAsignedTasksObject:(NSManagedObject *)value;
- (void)addAsignedTasks:(NSSet *)values;
- (void)removeAsignedTasks:(NSSet *)values;

@end

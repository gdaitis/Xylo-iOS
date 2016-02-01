//
//  XYEnsemble.h
//  xylo
//
//  Created by Lukas Kekys on 26/08/14.
//  Copyright (c) 2014 Seriously. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class XYEnsembleType, XYInstrumentType, XYOrganization, XYPosition, XYUser;

@interface XYEnsemble : NSManagedObject

@property (nonatomic, retain) NSString * coverImageUrl;
@property (nonatomic, retain) NSNumber * ensembleID;
@property (nonatomic, retain) NSString * facebook;
@property (nonatomic, retain) NSString * instagram;
@property (nonatomic, retain) NSString * logoImageUrl;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * phone;
@property (nonatomic, retain) NSString * twitter;
@property (nonatomic, retain) NSString * website;
@property (nonatomic, retain) NSString * youtube;
@property (nonatomic, retain) XYEnsembleType *ensembleType;
@property (nonatomic, retain) NSSet *instrumentTypes;
@property (nonatomic, retain) XYOrganization *parentOrganization;
@property (nonatomic, retain) NSSet *positions;
@property (nonatomic, retain) NSSet *users;
@end

@interface XYEnsemble (CoreDataGeneratedAccessors)

- (void)addInstrumentTypesObject:(XYInstrumentType *)value;
- (void)removeInstrumentTypesObject:(XYInstrumentType *)value;
- (void)addInstrumentTypes:(NSSet *)values;
- (void)removeInstrumentTypes:(NSSet *)values;

- (void)addPositionsObject:(XYPosition *)value;
- (void)removePositionsObject:(XYPosition *)value;
- (void)addPositions:(NSSet *)values;
- (void)removePositions:(NSSet *)values;

- (void)addUsersObject:(XYUser *)value;
- (void)removeUsersObject:(XYUser *)value;
- (void)addUsers:(NSSet *)values;
- (void)removeUsers:(NSSet *)values;

@end

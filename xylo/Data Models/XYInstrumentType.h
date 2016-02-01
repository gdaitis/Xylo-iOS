//
//  XYInstrumentType.h
//  xylo
//
//  Created by Lukas Kekys on 26/08/14.
//  Copyright (c) 2014 Seriously. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class XYEnsemble, XYUser;

@interface XYInstrumentType : NSManagedObject

@property (nonatomic, retain) NSString * hsNumber;
@property (nonatomic, retain) NSNumber * instrumentFamilyId;
@property (nonatomic, retain) NSNumber * instrumentGroupId;
@property (nonatomic, retain) NSNumber * instrumentTypeId;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * synonyms;
@property (nonatomic, retain) NSSet *ensembles;
@property (nonatomic, retain) NSSet *users;
@end

@interface XYInstrumentType (CoreDataGeneratedAccessors)

- (void)addEnsemblesObject:(XYEnsemble *)value;
- (void)removeEnsemblesObject:(XYEnsemble *)value;
- (void)addEnsembles:(NSSet *)values;
- (void)removeEnsembles:(NSSet *)values;

- (void)addUsersObject:(XYUser *)value;
- (void)removeUsersObject:(XYUser *)value;
- (void)addUsers:(NSSet *)values;
- (void)removeUsers:(NSSet *)values;

@end

//
//  XYPosition.h
//  xylo
//
//  Created by Lukas Kekys on 26/08/14.
//  Copyright (c) 2014 Seriously. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class XYEnsemble, XYUser;

@interface XYPosition : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * positionID;
@property (nonatomic, retain) XYEnsemble *ensemble;
@property (nonatomic, retain) NSSet *users;
@end

@interface XYPosition (CoreDataGeneratedAccessors)

- (void)addUsersObject:(XYUser *)value;
- (void)removeUsersObject:(XYUser *)value;
- (void)addUsers:(NSSet *)values;
- (void)removeUsers:(NSSet *)values;

@end

//
//  XYEnsembleType.h
//  xylo
//
//  Created by Lukas Kekys on 26/08/14.
//  Copyright (c) 2014 Seriously. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class XYEnsemble;

@interface XYEnsembleType : NSManagedObject

@property (nonatomic, retain) NSNumber * ensembleTypeID;
@property (nonatomic, retain) NSString * ensembleTypeName;
@property (nonatomic, retain) NSSet *ensemble;
@end

@interface XYEnsembleType (CoreDataGeneratedAccessors)

- (void)addEnsembleObject:(XYEnsemble *)value;
- (void)removeEnsembleObject:(XYEnsemble *)value;
- (void)addEnsemble:(NSSet *)values;
- (void)removeEnsemble:(NSSet *)values;

@end

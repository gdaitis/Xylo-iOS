//
//  XYPosition+PositionFunctions.m
//  xylo
//
//  Created by Lukas Kekys on 13/05/14.
//  Copyright (c) 2014 Seriously. All rights reserved.
//

#import "XYPosition+PositionFunctions.h"
#import "XYEnsemble.h"

@implementation XYPosition (PositionFunctions)

+ (void)importPositions:(id)data forEnsemble:(XYEnsemble *)ensemble
{
    NSManagedObjectContext *context = [NSManagedObjectContext MR_defaultContext];
    XYEnsemble *ensembleInCurrentContext = [ensemble MR_inContext:context];
    
    ensembleInCurrentContext.positions = nil;
    
    for (id dictionary in data) {
        //not importing via magical record to avoid complicated code
        NSNumber *positionID = [NSNumber numberWithInteger:[[dictionary valueForKey:@"Id"] integerValue]];
        
        NSPredicate *ensemblePredicate = [NSPredicate predicateWithFormat:@"ensemble == %@",ensembleInCurrentContext];
        NSPredicate *positionPredicate = [NSPredicate predicateWithFormat:@"positionID == %@",positionID];
        NSPredicate *compoundPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[ensemblePredicate,positionPredicate]];
        
        XYPosition *position = [XYPosition MR_findFirstWithPredicate:compoundPredicate inContext:context];
        if (!position) {
            position = [XYPosition MR_createInContext:context];
            position.positionID = positionID;
            position.name = [dictionary valueForKey:@"Name"];
        }
        [ensembleInCurrentContext addPositionsObject:position];
    }
    [context MR_saveOnlySelfAndWait];
}

@end

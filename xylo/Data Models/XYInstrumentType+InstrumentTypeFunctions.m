//
//  XYInstrumentType+InstrumentTypeFunctions.m
//  xylo
//
//  Created by Lukas Kekys on 20/06/14.
//  Copyright (c) 2014 Seriously. All rights reserved.
//

#import "XYInstrumentType+InstrumentTypeFunctions.h"
#import "XYEnsemble.h"

@implementation XYInstrumentType (InstrumentTypeFunctions)

+ (void)importInstruments:(id)data forEnsemble:(XYEnsemble *)ensemble
{
    NSManagedObjectContext *context = [NSManagedObjectContext MR_defaultContext];
    
    if ([data isKindOfClass:[NSArray class]]) {
        for (NSDictionary *dictionary in data) {
            
            XYInstrumentType *instrumentType = [XYInstrumentType MR_findFirstByAttribute:@"instrumentTypeId" withValue:dictionary[@"Id"] inContext:context];
            if (!instrumentType)
                instrumentType = [XYInstrumentType MR_createInContext:context];
            
            [instrumentType MR_importValuesForKeysWithObject:dictionary];
            [ensemble addInstrumentTypesObject:instrumentType];
        }
    }
    
    [context MR_saveOnlySelfAndWait];
}


//+ (void)importInstruments:(id)data forEnsemble:(XYEnsemble *)ensemble
//{
//    NSManagedObjectContext *context = [NSManagedObjectContext MR_defaultContext];
//    XYEnsemble *ensembleInCurrentContext = [ensemble MR_inContext:context];
//    
//    ensembleInCurrentContext.positions = nil;
//    
//    for (id dictionary in data) {
//        //not importing via magical record to avoid complicated code
//        NSNumber *positionID = [NSNumber numberWithInteger:[[dictionary valueForKey:@"Id"] integerValue]];
//        
//        NSPredicate *ensemblePredicate = [NSPredicate predicateWithFormat:@"ensemble == %@",ensembleInCurrentContext];
//        NSPredicate *positionPredicate = [NSPredicate predicateWithFormat:@"positionID == %@",positionID];
//        NSPredicate *compoundPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[ensemblePredicate,positionPredicate]];
//        
//        XYInstrumentType *position = [XYPosition MR_findFirstWithPredicate:compoundPredicate inContext:context];
//        if (!position) {
//            position = [XYPosition MR_createInContext:context];
//            position.positionID = positionID;
//            position.name = [dictionary valueForKey:@"Name"];
//        }
//        [ensembleInCurrentContext addPositionsObject:position];
//    }
//    [context MR_saveOnlySelfAndWait];
//}

@end

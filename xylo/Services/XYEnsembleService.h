//
//  XYEnsembleService.h
//  xylo
//
//  Created by Lukas Kekys on 12/05/14.
//  Copyright (c) 2014 Seriously. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XYEnsembleService : NSObject

+ (void)getEnsembleInfo:(NSNumber *)ensembleId;
+ (void)getEnsembleInfoWithId:(NSNumber *)identifier
                 successBlock:(void (^)(void))successBlock
                 failureBlock:(void (^)(void))failureBlock;

+ (void)getInstrumentsForEnsembles:(NSSet *)ensembleSet
                      successBlock:(void (^)(void))successBlock
                      failureBlock:(void (^)(void))failureBlock;

@end

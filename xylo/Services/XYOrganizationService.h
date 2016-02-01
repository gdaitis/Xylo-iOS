//
//  XYOrganizationServise.h
//  xylo
//
//  Created by Lukas Kekys on 28/04/14.
//  Copyright (c) 2014 Seriously. All rights reserved.
//

#import <Foundation/Foundation.h>

@class XYEnsemble;

typedef NS_ENUM(NSInteger, XYOrganizationServiceCodeCheckError) {
    XYOrganizationServiceCodeCheckErrorNone = 0,
    XYOrganizationServiceCodeCheckErrorOrganizationDoesntExist
};

@interface XYOrganizationService : NSObject

+ (void)getEnsemblePositions:(XYEnsemble *)ensemble
                successBlock:(void (^)(void))successBlock
                failureBlock:(void (^)(void))failureBlock;

+ (void)getPositionsForEnsembles:(NSSet *)ensembleSet
                    successBlock:(void (^)(void))successBlock
                    failureBlock:(void (^)(void))failureBlock;


+ (void)getOrganizationInfoWithId:(NSNumber *)identifier
                     successBlock:(void (^)(void))successBlock
                     failureBlock:(void (^)(XYOrganizationServiceCodeCheckError codeCheckError))failureBlock;

+ (void)getEnsemblesForOrganizationWithStringId:(NSString *)identifier
                                   successBlock:(void (^)(void))successBlock
                                   failureBlock:(void (^)(void))failureBlock;

+ (void)getMasterUserOrganizationsSuccessBlock:(void (^)(void))successBlock
                                  failureBlock:(void (^)(XYOrganizationServiceCodeCheckError codeCheckError))failureBlock;

@end

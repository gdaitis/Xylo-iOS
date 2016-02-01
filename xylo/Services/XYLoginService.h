//
//  XYLoginService.h
//  xylo
//
//  Created by Lukas Kekys on 2/24/14.
//  Copyright (c) 2014 Seriously. All rights reserved.
//

#import <Foundation/Foundation.h>

@class XYOrganization,XYUser;

typedef NS_ENUM(NSInteger, XYLoginServiceCodeCheckError) {
    XYLoginServiceCodeCheckErrorNone = 0,
    XYLoginServiceCodeCheckErrorInactiveCode,
    XYLoginServiceCodeCheckErrorIndividualCode
};

@interface XYLoginService : NSObject

+ (void)loginUserWithEmail:(NSString *)email
                  password:(NSString *)password
              successBlock:(void (^)(void))successBlock
              failureBlock:(void (^)(void))failureBlock;

+ (void)logout;

+ (void)registerUserWithName:(NSString *)name
                    lastName:(NSString *)lastname
                       email:(NSString *)email
                    password:(NSString *)password
         andRepeatedPassword:(NSString *)repeatedPassword
                successBlock:(void (^)(void))successBlock
                failureBlock:(void (^)(NSString *errorMessage))failureBlock;

+ (void)forgotPasswordForEmail:(NSString *)email
                  successBlock:(void (^)(void))successBlock
                  failureBlock:(void (^)(void))failureBlock;

+ (void)resetPasswordForToken:(NSString *)token
                  newPassword:(NSString *)newPassword
              confirmPassword:(NSString *)confirmPassword
                 successBlock:(void (^)(void))successBlock
                 failureBlock:(void (^)(void))failureBlock;

+ (void)checkCodeWithCodeString:(NSString *)codeString
                   successBlock:(void (^)(XYOrganization *organization, XYLoginServiceCodeCheckError codeCheckError))successBlock
                   failureBlock:(void (^)(void))failureBlock;

+ (void)getMasterUserInfoSuccessBlock:(void (^)(void))successBlock
                         failureBlock:(void (^)(void))failureBlock;

+ (void)cleanUpUserSession;

@end

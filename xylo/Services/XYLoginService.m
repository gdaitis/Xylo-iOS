//
//  XYLoginService.m
//  xylo
//
//  Created by Lukas Kekys on 2/24/14.
//  Copyright (c) 2014 Seriously. All rights reserved.
//

#import "XYLoginService.h"
#import "XYAPIClient.h"
#import "XYErrorService.h"
#import "JSONResponseSerializerWithData.h"
#import "XYEnsemble+EnsembleFunctions.h"
#import "XYUser+UserFunctions.h"
#import "XYUser.h"

#import <AFNetworking.h>
#import <SSKeychain.h>

#import "XYOrganization+OrganizationFunctions.h"
#import "XYOrganizationsListModel.h"
#import "XYTaskListModel.h"

@implementation XYLoginService

+ (void)loginUserWithEmail:(NSString *)email
                  password:(NSString *)password
              successBlock:(void (^)(void))successBlock
              failureBlock:(void (^)(void))failureBlock
{
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:kXYAPIClientBaseXyloURLString]];
    [manager setRequestSerializer:[AFHTTPRequestSerializer serializer]];
    [manager setResponseSerializer:[JSONResponseSerializerWithData serializer]];
    
    [manager POST:@"/api/Account/Token"
       parameters:@{@"username": email,
                    @"password": password,
                    @"grant_type": @"password"}
          success:^(NSURLSessionDataTask *task, id responseObject) {
              
              [self saveAccessTokenFromResponse:responseObject];
              [self getMasterUserInfoSuccessBlock:^ {
                  if (successBlock)
                      successBlock();
                  
              } failureBlock:^{
                  if (failureBlock)
                      failureBlock();
              }];
          } failure:^(NSURLSessionDataTask *task, NSError *error) {
              if (failureBlock)
                  failureBlock();
          }];
}

+ (void)logout
{
    NSLog(@"LOGOUT INITIATED");
    
    [[XYAPIClient sharedClient] logout];
}

+ (void)saveAccessTokenFromResponse:(id)response
{
    [XYAPIClient sharedClient].loggedOut = NO;
    NSString *accessToken = [response objectForKey:@"access_token"];
    NSString *username = [response objectForKey:@"userName"];
    NSString *authorization = [NSString stringWithFormat:@"Bearer %@", accessToken];
    [[NSUserDefaults standardUserDefaults] setValue:username forKey:@"username"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[XYAPIClient sharedClient].requestSerializer setValue:authorization
                                        forHTTPHeaderField:@"Authorization"];
    [SSKeychain setPassword:accessToken
                 forService:kXYAPIClientKeychainServiceName
                    account:username];
}

+ (void)getMasterUserInfoSuccessBlock:(void (^)(void))successBlock
                         failureBlock:(void (^)(void))failureBlock
{
    NSString *pathString = [NSString stringWithFormat:@"/api/users/me"];
    
    [[XYAPIClient sharedClient] GET:pathString
                         parameters:nil
                            success:^(NSURLSessionDataTask *task, id JSON) {
                                
                                [XYUser updateUserFromResponse:JSON];
                                [[NSNotificationCenter defaultCenter] postNotificationName:kUpdateLeftMenuNotification object:nil];
                                
                                if (successBlock)
                                    successBlock();

                            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                if (failureBlock)
                                    failureBlock();
                            }];
}

+ (void)registerUserWithName:(NSString *)name
                    lastName:(NSString *)lastname
                       email:(NSString *)email
                    password:(NSString *)password
         andRepeatedPassword:(NSString *)repeatedPassword
                successBlock:(void (^)(void))successBlock
                failureBlock:(void (^)(NSString *errorMessage))failureBlock
{
    [[XYAPIClient sharedClient] POST:@"/api/account/register"
                          parameters:@{@"UserName":email,
                                       @"FirstName":name,
                                       @"LastName":lastname,
                                       @"Password":password,
                                       @"ConfirmPassword":repeatedPassword}
                             success:^(NSURLSessionDataTask *task, id responseObject) {
                                 
                                 if (successBlock)
                                     successBlock();
                             } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                 
                                 NSString *errorMessage = [XYErrorService handleRegistrationError:error withDataTask:task];
                                 NSString *result = (errorMessage) ? errorMessage : @"Something went wrong, please try again later";
                                 if (failureBlock)
                                     failureBlock(result);
                             }];
}

+ (void)forgotPasswordForEmail:(NSString *)email
                  successBlock:(void (^)(void))successBlock
                  failureBlock:(void (^)(void))failureBlock
{
    [[XYAPIClient sharedClient] POST:@"api/Account/ForgotPassword"
                          parameters:@{@"Email": email}
                             success:^(NSURLSessionDataTask *task, id responseObject) {
                                 if (successBlock)
                                     successBlock();
                             } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                 if (failureBlock)
                                     failureBlock();
                             }];
}

+ (void)resetPasswordForToken:(NSString *)token
                  newPassword:(NSString *)newPassword
              confirmPassword:(NSString *)confirmPassword
                 successBlock:(void (^)(void))successBlock
                 failureBlock:(void (^)(void))failureBlock
{
    [[XYAPIClient sharedClient] POST:@"api/Account/ResetPassword"
                          parameters:@{@"Token":token,
                                       @"Password":newPassword,
                                       @"ConfirmPassword":confirmPassword}
                             success:^(NSURLSessionDataTask *task, id responseObject) {
                                 if (successBlock)
                                     successBlock();
                             } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                 if (failureBlock)
                                     failureBlock();
                             }];
}

+ (void)checkCodeWithCodeString:(NSString *)codeString
                   successBlock:(void (^)(XYOrganization *organization, XYLoginServiceCodeCheckError codeCheckError))successBlock
                   failureBlock:(void (^)(void))failureBlock
{
    NSString *pathString = [NSString stringWithFormat:@"/api/invitations/getByKey/%@?type=json", codeString];
    [[XYAPIClient sharedClient] GET:pathString
                         parameters:nil
                            success:^(NSURLSessionDataTask *task, id JSON) {
                                
                                BOOL isActive = [[JSON valueForKey:@"IsActive"] boolValue];
                                if (!isActive) {
                                    if (successBlock)
                                        successBlock(nil, XYLoginServiceCodeCheckErrorInactiveCode);
                                }
                                NSInteger invitationLinkTypeId = [[JSON valueForKey:@"InvitationLinkTypeId"] intValue];
                                if (invitationLinkTypeId == 1) {
                                    if (successBlock)
                                        successBlock(nil, XYLoginServiceCodeCheckErrorIndividualCode);
                                }
                                
                                XYOrganization *organization = [XYOrganization updateOrganizationFromResponse:JSON];
                                
                                if (successBlock)
                                    successBlock(organization, XYLoginServiceCodeCheckErrorNone);
                                
                            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                
                                if (failureBlock)
                                    failureBlock();
                                
                            }];
}


#pragma mark - User session

+ (void)cleanUpUserSession
{
    // TODO: same functionality as in SigningDay's SDLoginService.h

    [[XYAPIClient sharedClient].requestSerializer setValue:nil forHTTPHeaderField:@"Authorization"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"access_token"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:XYLeftMenuViewControllerListUpdateDate];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:XYTaskListUpdateDate];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

@end




















//
//  XYOrganizationServise.m
//  xylo
//
//  Created by Lukas Kekys on 28/04/14.
//  Copyright (c) 2014 Seriously. All rights reserved.
//

#import "XYOrganizationService.h"
#import "XYAPIClient.h"
#import "XYPosition+PositionFunctions.h"
#import "XYEnsemble+EnsembleFunctions.h"
#import "XYUser+UserFunctions.h"
#import "AFHTTPRequestOperationManager.h"
#import "AFHTTPRequestOperation.h"
#import "XYAPIClient.h"
#import "XYOrganization+OrganizationFunctions.h"
#import <SSKeychain.h>

#import "XYOrganizationsListModel.h"

@implementation XYOrganizationService

+ (void)getEnsemblePositions:(XYEnsemble *)ensemble
                successBlock:(void (^)(void))successBlock
                failureBlock:(void (^)(void))failureBlock
{
    NSString *pathString = [NSString stringWithFormat:@"/api/organizations/%@/positions?type=json",[ensemble.ensembleID stringValue]];
    [[XYAPIClient sharedClient] GET:pathString
                         parameters:nil
                            success:^(NSURLSessionDataTask *task, id JSON) {
                                
                                [XYPosition importPositions:JSON forEnsemble:ensemble];
                                
                            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                if (failureBlock)
                                    failureBlock();
                            }];
}

+ (void)getPositionsForEnsembles:(NSSet *)ensembleSet
                    successBlock:(void (^)(void))successBlock
                    failureBlock:(void (^)(void))failureBlock
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSError *error = nil;
    NSString *username = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
    if (username) {
        NSString *token = [SSKeychain passwordForService:kXYAPIClientKeychainServiceName
                                                 account:username];
        NSString *authorization = [NSString stringWithFormat:@"Bearer %@", token];
        [manager.requestSerializer setValue:authorization forHTTPHeaderField:@"Authorization"];
    }
    
    NSMutableArray *operationsArray = [[NSMutableArray alloc] init];
    
    for (XYEnsemble *ensemble in ensembleSet) {
        
        NSString *urlString = [NSString stringWithFormat:@"%@/api/organizations/%@/positions?type=json",kXYAPIClientBaseXyloURLString,[ensemble.ensembleID stringValue]];
        
        NSMutableURLRequest *request = [manager.requestSerializer requestWithMethod:@"GET" URLString:urlString parameters:nil error:&error];
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        
        [operation setResponseSerializer:[AFJSONResponseSerializer alloc]];
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            [XYPosition importPositions:responseObject forEnsemble:ensemble];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"error = %@",error);
        }];
        
        [operationsArray addObject:operation];
    }
    
    NSArray *batches = [AFURLConnectionOperation batchOfRequestOperations:operationsArray progressBlock:^(NSUInteger numberOfFinishedOperations, NSUInteger totalNumberOfOperations) {
        
    } completionBlock:^(NSArray *operations) {
        
        if (successBlock)
            successBlock();
    }];
    
    [manager.operationQueue addOperations:batches waitUntilFinished:NO];
}

+ (void)getOrganizationInfoWithId:(NSNumber *)identifier
                     successBlock:(void (^)(void))successBlock
                     failureBlock:(void (^)(XYOrganizationServiceCodeCheckError codeCheckError))failureBlock
{
    NSString *pathString = [NSString stringWithFormat:@"/api/organizations/%@?type=json",[identifier stringValue]];
    
    [[XYAPIClient sharedClient] GET:pathString
                         parameters:nil
                            success:^(NSURLSessionDataTask *task, id JSON) {
                                
                                [XYOrganization updateOrganizationFromResponse:JSON];
                                
                                if (successBlock)
                                    successBlock();
                            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                if (failureBlock)
                                    failureBlock(error.code);
                            }];
}

+ (void)getEnsemblesForOrganizationWithStringId:(NSString *)identifier
                                   successBlock:(void (^)(void))successBlock
                                   failureBlock:(void (^)(void))failureBlock
{
    NSString *pathString = [NSString stringWithFormat:@"/api/organizations/%@/ensembles?type=json",identifier];
    
    [[XYAPIClient sharedClient] GET:pathString
                         parameters:nil
                            success:^(NSURLSessionDataTask *task, id JSON) {
                                
                                NSManagedObjectContext *context = [NSManagedObjectContext MR_defaultContext];
                                XYOrganization *organization = [XYOrganization MR_findFirstByAttribute:@"organizationID" withValue:[NSNumber numberWithInt:[identifier intValue]] inContext:context];
                                [XYEnsemble updateEnsemblesFromResponse:JSON forOrganization:organization inContext:context];
                                [context MR_saveOnlySelfAndWait];
                                
//                                NSSet *ensembles = organization.ensembles;
                                
                                if (successBlock)
                                    successBlock();
                            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                if (failureBlock)
                                    failureBlock();
                            }];
}

+ (void)getMasterUserOrganizationsSuccessBlock:(void (^)(void))successBlock
                                  failureBlock:(void (^)(XYOrganizationServiceCodeCheckError codeCheckError))failureBlock
{
    NSString *pathString = [NSString stringWithFormat:@"/api/users/me/organizations?type=json"];
    [[XYAPIClient sharedClient] GET:pathString
                         parameters:nil
                            success:^(NSURLSessionDataTask *task, id JSON) {
                                
                                [XYOrganization updateOrganizationsFromResponse:JSON];
                                
                                [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:XYLeftMenuViewControllerListUpdateDate];
                                [[NSUserDefaults standardUserDefaults] synchronize];
                                
                                if (successBlock)
                                    successBlock();
                            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                if (failureBlock)
                                    failureBlock(error.code);
                            }];
}

@end

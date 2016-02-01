//
//  XYEnsembleService.m
//  xylo
//
//  Created by Lukas Kekys on 12/05/14.
//  Copyright (c) 2014 Seriously. All rights reserved.
//

#import "XYEnsembleService.h"
#import "XYEnsemble.h"
#import "XYAPIClient.h"
#import <SSKeychain.h>
#import "XYInstrumentType+InstrumentTypeFunctions.h"
#import "XYOrganizationService.h"
#import "XYEnsemble+EnsembleFunctions.h"
#import "XYOrganization.h"

#import <AFHTTPRequestOperationManager.h>

@implementation XYEnsembleService

+ (void)getEnsembleInfo:(NSNumber *)ensembleId
{
    NSString *pathString = [NSString stringWithFormat:@"/api/ensembles/%@?type=json",[ensembleId stringValue]];
    [[XYAPIClient sharedClient] GET:pathString
                         parameters:nil
                            success:^(NSURLSessionDataTask *task, id JSON) {
                                
                                NSLog(@"json = %@",JSON);
                                
                            } failure:^(NSURLSessionDataTask *task, NSError *error) {

                            }];
}

+ (void)getInstrumentsForEnsembles:(NSSet *)ensembleSet
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
        
        NSString *urlString = [NSString stringWithFormat:@"%@/api/ensembles/%@/instrumentTypes?type=json",kXYAPIClientBaseXyloURLString,[ensemble.ensembleID stringValue]];
        
        NSMutableURLRequest *request = [manager.requestSerializer requestWithMethod:@"GET" URLString:urlString parameters:nil error:&error];
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        
        [operation setResponseSerializer:[AFJSONResponseSerializer alloc]];
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            [XYInstrumentType importInstruments:responseObject forEnsemble:ensemble];
            
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

+ (void)getEnsembleInfoWithId:(NSNumber *)identifier
                 successBlock:(void (^)(void))successBlock
                 failureBlock:(void (^)(void))failureBlock
{
    NSString *pathString = [NSString stringWithFormat:@"/api/organizations/%@?type=json",[identifier stringValue]];
    
    [[XYAPIClient sharedClient] GET:pathString
                         parameters:nil
                            success:^(NSURLSessionDataTask *task, id JSON) {
                                
                                NSManagedObjectContext *context = [NSManagedObjectContext MR_defaultContext];
                                XYOrganization *organization = [XYOrganization MR_findFirstByAttribute:@"organizationID" withValue:[NSNumber numberWithInt:[identifier intValue]] inContext:context];
                                [XYEnsemble updateEnsemblesFromResponse:@[JSON] forOrganization:organization inContext:context];
                                [context MR_saveOnlySelfAndWait];
                                
                                if (successBlock)
                                    successBlock();
                            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                if (failureBlock)
                                    failureBlock();
                            }];
}

@end

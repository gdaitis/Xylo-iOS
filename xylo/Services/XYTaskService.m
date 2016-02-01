//
//  XYTaskService.m
//  xylo
//
//  Created by Lukas Kekys on 26/08/14.
//  Copyright (c) 2014 Seriously. All rights reserved.
//

#import "XYTaskService.h"
#import "XYAPIClient.h"
#import "XYTask+TaskFunctions.h"
#import "XYTaskListModel.h"

@implementation XYTaskService

+ (void)getMasterUserTodayTasksSuccessBlock:(void (^)(void))successBlock
                               failureBlock:(void (^)(void))failureBlock
{
    NSString *pathString = [NSString stringWithFormat:@"/api/me/tasks/today?type=json"];
    [[XYAPIClient sharedClient] GET:pathString
                         parameters:nil
                            success:^(NSURLSessionDataTask *task, id JSON) {
                                
                                [XYTask updateMasterUserTasksFromResponse:JSON];
                                
                                [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:XYTaskListUpdateDate];
                                [[NSUserDefaults standardUserDefaults] synchronize];
                                
                                if (successBlock)
                                    successBlock();
                            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                if (failureBlock)
                                    failureBlock();
                            }];
}

+ (void)getMasterUserUpcomingTasksSuccessBlock:(void (^)(void))successBlock
                                  failureBlock:(void (^)(void))failureBlock
{
    NSString *pathString = [NSString stringWithFormat:@"/api/me/tasks/upcoming?type=json"];
    [[XYAPIClient sharedClient] GET:pathString
                         parameters:nil
                            success:^(NSURLSessionDataTask *task, id JSON) {
                                
                                [XYTask updateMasterUserTasksFromResponse:JSON];
                                
                                [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:XYTaskListUpdateDate];
                                [[NSUserDefaults standardUserDefaults] synchronize];
                                
                                if (successBlock)
                                    successBlock();
                            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                if (failureBlock)
                                    failureBlock();
                            }];
}

+ (void)markTaskAsCompleted:(XYTask *)taskObject
    successBlock:(void (^)(XYTask *resultTask))successBlock
    failureBlock:(void (^)(void))failureBlock
{
    
    NSString *completedString = ([taskObject.isCompleted boolValue]) ? @"false" : @"true";
    
    NSString *pathString = [NSString stringWithFormat:@"api/tasks/%d/markCompleted?isCompleted=%@",[taskObject.taskID intValue],completedString];
    
    [[XYAPIClient sharedClient] PUT:pathString
                         parameters:nil
                            success:^(NSURLSessionDataTask *task, id responseObject) {
                                
                                NSManagedObjectContext *context = [NSManagedObjectContext MR_defaultContext];
                                XYTask *taskInCurrentContext = [taskObject MR_inContext:context];
                                
                                taskInCurrentContext.isCompleted = ([taskInCurrentContext.isCompleted boolValue]) ? [NSNumber numberWithBool:NO] : [NSNumber numberWithBool:YES];
                                [context MR_saveToPersistentStoreAndWait];
                                
                                if (successBlock)
                                    successBlock(taskInCurrentContext);
                                
                            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                
                                if (failureBlock)
                                    failureBlock();
                            }];
}

+ (void)markTask:(XYTask *)taskObject
    successBlock:(void (^)(XYTask *resultTask))successBlock
    failureBlock:(void (^)(void))failureBlock
{
    
    NSString *favoriteString = ([taskObject.isMarked boolValue]) ? @"false" : @"true";
    
    NSString *pathString = [NSString stringWithFormat:@"api/tasks/%d/mark?isMarked=%@",[taskObject.taskID intValue],favoriteString];
    
    [[XYAPIClient sharedClient] PUT:pathString
                         parameters:nil
                            success:^(NSURLSessionDataTask *task, id responseObject) {
                                
                                NSManagedObjectContext *context = [NSManagedObjectContext MR_defaultContext];
                                XYTask *taskInCurrentContext = [taskObject MR_inContext:context];
                                
                                taskInCurrentContext.isMarked = ([taskInCurrentContext.isMarked boolValue]) ? [NSNumber numberWithBool:NO] : [NSNumber numberWithBool:YES];
                                [context MR_saveToPersistentStoreAndWait];
                                
                                if (successBlock)
                                    successBlock(taskInCurrentContext);
                                
                            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                
                                if (failureBlock)
                                    failureBlock();
                            }];
}

@end

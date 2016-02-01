//
//  XYTaskService.h
//  xylo
//
//  Created by Lukas Kekys on 26/08/14.
//  Copyright (c) 2014 Seriously. All rights reserved.
//

#import <Foundation/Foundation.h>

@class XYTask;

@interface XYTaskService : NSObject

+ (void)getMasterUserTodayTasksSuccessBlock:(void (^)(void))successBlock
                               failureBlock:(void (^)(void))failureBlock;
+ (void)getMasterUserUpcomingTasksSuccessBlock:(void (^)(void))successBlock
                                  failureBlock:(void (^)(void))failureBlock;
+ (void)markTaskAsCompleted:(XYTask *)taskObject
               successBlock:(void (^)(XYTask *resultTask))successBlock
               failureBlock:(void (^)(void))failureBlock;
+ (void)markTask:(XYTask *)taskObject
    successBlock:(void (^)(XYTask *resultTask))successBlock
    failureBlock:(void (^)(void))failureBlock;


@end

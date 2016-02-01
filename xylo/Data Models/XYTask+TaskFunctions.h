//
//  XYTask+TaskFunctions.h
//  xylo
//
//  Created by Lukas Kekys on 26/08/14.
//  Copyright (c) 2014 Seriously. All rights reserved.
//

#import "XYTask.h"

@interface XYTask (TaskFunctions)

+ (void)updateMasterUserTasksFromResponse:(id)response;
+ (NSArray *)masterUserTodayTasksIncludingSet:(NSSet *)taskSet;
+ (NSArray *)masterUserUpcomingTasksIncludingSet:(NSSet *)taskSet;
+ (void)markCurrentUserTasksForDeletion;
+ (void)deleteCurrentUsersMarkedTasks;

- (NSString *)taskRepeatString;

@end

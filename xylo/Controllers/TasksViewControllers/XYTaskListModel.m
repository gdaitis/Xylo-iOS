//
//  XYTaskListModel.m
//  xylo
//
//  Created by Lukas Kekys on 26/08/14.
//  Copyright (c) 2014 Seriously. All rights reserved.
//

#import "XYTaskListModel.h"
#import "XYTask+TaskFunctions.h"
#import "XYTaskService.h"

NSString * const XYTaskListUpdateDate = @"XYTaskListUpdateDate";

@implementation XYTaskListModel

- (id)init
{
    self = [super init];
    if (self) {
        [self setupListModel];
    }
    return self;
}

- (void)setupListModel
{
    [self reloadCompletedTasks];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadTasks) name:kTaskListUpdatedNotification object:nil];
      //[[NSNotificationCenter defaultCenter] postNotificationName:kTaskListUpdatedNotification object:nil];
}
//
//- (void)dealloc
//{
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:kTaskListUpdatedNotification object:nil];
//}


- (void)loadTasks
{
    NSArray *todayTaskArray = [XYTask masterUserTodayTasksIncludingSet:self.completedTasksToShowUntilReload];
    self.todayTasksArray = todayTaskArray;
    
    NSArray *upcomingTaskArray = [XYTask masterUserUpcomingTasksIncludingSet:self.completedTasksToShowUntilReload];
    self.upcomingTasksArray = upcomingTaskArray;
    
    [self tasksUpdated];
}

- (void)tasksUpdated
{
    [self.delegate taskListChanged:self];
}

- (void)updateListModelIfNeeded
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSDate *lastUpdated = [userDefaults objectForKey:XYTaskListUpdateDate];
    
    if (lastUpdated != nil) {
        
        int timeDifference = [[NSDate date] timeIntervalSinceDate:lastUpdated];
        if (timeDifference < 120) {
            return;
        }
        else {
            [self downloadTasks];
        }
    }
    else {
        [self downloadTasks];
    }
}

- (void)downloadTasks
{
    //mark tasks for deletion after all tasks have been downloaded
    [XYTask markCurrentUserTasksForDeletion];
    
    //tasks loaded and delegated only in "downloadUpcomingTasks" success or failure blocks to avoid lots of glitching
    [XYTaskService getMasterUserTodayTasksSuccessBlock:^ {
        
        [self downloadUpcomingTasks];
    } failureBlock:^{
        [self downloadUpcomingTasks];
    }];
}

- (void)downloadUpcomingTasks
{
    [XYTaskService getMasterUserUpcomingTasksSuccessBlock:^ {
        [XYTask deleteCurrentUsersMarkedTasks];
        
        [self loadTasks];
    } failureBlock:^{
        [self loadTasks];
    }];
}

- (void)addRemoveVisibleTasks:(XYTask *)task
{
    if ([task.isCompleted boolValue]) {
        [self.completedTasksToShowUntilReload addObject:task.taskID];
    }
    else {
        [self.completedTasksToShowUntilReload removeObject:task.taskID];
    }
    NSLog(@"self.completedTasksToShowUntilReload = %@",self.completedTasksToShowUntilReload);
}


- (void)reloadCompletedTasks
{
    self.completedTasksToShowUntilReload = nil;
    NSMutableSet *set = [[NSMutableSet alloc] init];
    self.completedTasksToShowUntilReload = set;
}

@end



//
//  XYTaskListModel.h
//  xylo
//
//  Created by Lukas Kekys on 26/08/14.
//  Copyright (c) 2014 Seriously. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const XYTaskListUpdateDate;

@class XYTaskListModel,XYTask;

@protocol XYTaskListModelDelegate <NSObject>

@optional
- (void)taskListChanged:(XYTaskListModel *)taskListModel;

@end

@interface XYTaskListModel : NSObject

@property (nonatomic, weak) id <XYTaskListModelDelegate> delegate;
@property (nonatomic, strong) NSArray *todayTasksArray;
@property (nonatomic, strong) NSArray *upcomingTasksArray;
@property (nonatomic, strong) NSMutableSet *completedTasksToShowUntilReload;

- (void)loadTasks;
- (void)reloadCompletedTasks;
- (void)downloadTasks;
- (void)updateListModelIfNeeded;
- (void)addRemoveVisibleTasks:(XYTask *)task;


@end

//
//  XYTask+TaskFunctions.m
//  xylo
//
//  Created by Lukas Kekys on 26/08/14.
//  Copyright (c) 2014 Seriously. All rights reserved.
//

#import "XYTask+TaskFunctions.h"
#import "NSDictionary+NullConverver.h"
#import "XYUser+UserFunctions.h"
#import "XYUtils.h"

@implementation XYTask (TaskFunctions)

+ (void)updateMasterUserTasksFromResponse:(id)response
{
    //save tasks to database and save them
    NSManagedObjectContext *context = [NSManagedObjectContext MR_defaultContext];
    
    if ([response isKindOfClass:[NSArray class]]) {
        
#warning need to delete old tasks from database
        XYUser *masterUser = [XYUser masterUserInContext:context];
        
        for (NSDictionary *dict in response) {
            
            NSDictionary *dictionary = [dict dictionaryByReplacingNullsWithStrings];
            XYTask *task = [self updateTasksFromDictionary:dictionary inContext:context];
            task.asignedTo = masterUser;
        }
    }
    else if ([response isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dictionary = [response dictionaryByReplacingNullsWithStrings];
        [self updateTasksFromDictionary:dictionary inContext:context];
    }
    
    [context MR_saveToPersistentStoreAndWait];
}

+ (XYTask *)updateTasksFromDictionary:(NSDictionary *)dictionary inContext:(NSManagedObjectContext *)context
{
    NSNumber *taskID = [NSNumber numberWithInteger:[dictionary[@"Id"] integerValue]];
    
    XYTask *task = [XYTask MR_findFirstByAttribute:@"taskID" withValue:taskID inContext:context];
    if (!task) {
        task = [XYTask MR_createInContext:context];
        task.taskID = taskID;
    }
    task.taskDescription = dictionary[@"Description"];
    task.dueDate = [XYUtils dateFromString:dictionary[@"DueDate"]];
    task.isCompleted = [NSNumber numberWithInt:[dictionary[@"IsCompleted"] intValue]];
    task.isMarked = [NSNumber numberWithInt:[dictionary[@"IsMarked"] intValue]];
    task.isRecurring = [NSNumber numberWithInt:[dictionary[@"IsRecurring"] intValue]];
    task.name = dictionary[@"Name"];
    task.repeat = dictionary[@"Repeat"];
    task.shouldBeDeleted = [NSNumber numberWithBool:NO];
    
    task.runAt = nil;
    if ([dictionary[@"RunAt"] isKindOfClass:[NSArray class]]) {
        NSString * result = [dictionary[@"RunAt"] componentsJoinedByString:@","];
        task.runAt = result;
    }
    return task;
}

+ (NSArray *)masterUserTodayTasksIncludingSet:(NSSet *)taskSet
{
    NSManagedObjectContext *context = [NSManagedObjectContext MR_defaultContext];
    XYUser *masterUser = [XYUser masterUserInContext:context];
    
    //adding 24 hours and getting next day
    NSDate *nextDay = [[NSDate date] dateByAddingTimeInterval:60*60*24];
    
    NSDateComponents *nextDayComponents = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit
                                                                        fromDate:nextDay];
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"dueDate < %@ || isMarked == %@",[cal dateFromComponents:nextDayComponents],[NSNumber numberWithBool:YES]];
    
    NSPredicate *completedPredicate = [NSPredicate predicateWithFormat:@"isCompleted == %@ || taskID IN %@",[NSNumber numberWithBool:NO],[taskSet allObjects]];
    NSPredicate *compoundPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[predicate,completedPredicate]];
    
    NSSet *filteredSet = [masterUser.asignedTasks filteredSetUsingPredicate:compoundPredicate];
    NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"dueDate" ascending:YES];
    NSArray *todayTasks = [filteredSet sortedArrayUsingDescriptors:@[descriptor]];
    
    return todayTasks;
}

+ (NSArray *)masterUserUpcomingTasksIncludingSet:(NSSet *)taskSet
{
    NSManagedObjectContext *context = [NSManagedObjectContext MR_defaultContext];
    XYUser *masterUser = [XYUser masterUserInContext:context];
    
    //adding 24 hours and getting next day
    NSDate *nextDay = [[NSDate date] dateByAddingTimeInterval:60*60*24];
    
    NSDateComponents *nextDayComponents = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit
                                                                          fromDate:nextDay];
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"dueDate >= %@ && isMarked == %@",[cal dateFromComponents:nextDayComponents],[NSNumber numberWithBool:NO]];
    NSPredicate *completedPredicate = [NSPredicate predicateWithFormat:@"isCompleted == %@ || taskID IN %@",[NSNumber numberWithBool:NO],[taskSet allObjects]];
    NSPredicate *compoundPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[predicate,completedPredicate]];
    
    NSSet *filteredSet = [masterUser.asignedTasks filteredSetUsingPredicate:compoundPredicate];
    NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"dueDate" ascending:YES];
    NSArray *upcomingTasks = [filteredSet sortedArrayUsingDescriptors:@[descriptor]];
    
    return upcomingTasks;
}

+ (void)markCurrentUserTasksForDeletion
{
    NSManagedObjectContext *context = [NSManagedObjectContext MR_defaultContext];
    XYUser *masterUser = [XYUser masterUser];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"asignedTo == %@",masterUser];
    NSArray *tasks = [XYTask MR_findAllWithPredicate:predicate inContext:context];
    
    for (XYTask *task in tasks) {
        task.shouldBeDeleted = [NSNumber numberWithBool:YES];
    }
    
    [context MR_saveToPersistentStoreAndWait];
}

+ (void)deleteCurrentUsersMarkedTasks
{
    NSManagedObjectContext *context = [NSManagedObjectContext MR_defaultContext];
    XYUser *masterUser = [XYUser masterUser];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"asignedTo == %@",masterUser];
    NSArray *tasks = [XYTask MR_findAllWithPredicate:predicate inContext:context];
    
    for (XYTask *task in tasks) {
        
        if ([task.shouldBeDeleted boolValue]) {
            [task MR_deleteInContext:context];
        }
    }
    
    [context MR_saveToPersistentStoreAndWait];
    
}

- (NSString *)taskRepeatString
{
    NSString *result = @"Never";
    if (self.repeat !=nil || ![self.repeat isEqualToString:@""] ) {
        if ([[self.repeat lowercaseString] isEqualToString:@"w"]) {
            result = @"Every week";
        }
        else if ([[self.repeat lowercaseString] isEqualToString:@"m"]) {
            result = @"Every month";
        }
    }
    
    return result;
}

@end

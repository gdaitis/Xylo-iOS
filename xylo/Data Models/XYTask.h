//
//  XYTask.h
//  xylo
//
//  Created by Lukas Kekys on 29/08/14.
//  Copyright (c) 2014 Seriously. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class XYUser;

@interface XYTask : NSManagedObject

@property (nonatomic, retain) NSDate * dueDate;
@property (nonatomic, retain) NSNumber * isCompleted;
@property (nonatomic, retain) NSNumber * isMarked;
@property (nonatomic, retain) NSString * taskDescription;
@property (nonatomic, retain) NSNumber * taskID;
@property (nonatomic, retain) NSNumber * isRecurring;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * repeat;
@property (nonatomic, retain) NSString * runAt;
@property (nonatomic, retain) NSNumber * shouldBeDeleted;
@property (nonatomic, retain) XYUser *asignedTo;

@end

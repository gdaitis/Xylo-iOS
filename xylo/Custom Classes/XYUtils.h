//
//  XYUtils.h
//  xylo
//
//  Created by Lukas Kekys on 13/03/14.
//  Copyright (c) 2014 Seriously. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XYUtils : NSObject

//+ (void)setupCoreDataStack;
+ (BOOL)emailFormatValid:(NSString *)email;
+ (NSDate *)dateFromString:(NSString *)dateString;
+ (NSDictionary *)timeLeftFromDate:(NSDate *)date;
+ (NSString *)formatedLocalizedDateStringFromDate:(NSDate *)date;
+ (NSString *)formatedDateWithoutHoursStringFromDate:(NSDate *)date;

@end

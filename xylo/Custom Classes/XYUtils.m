//
//  XYUtils.m
//  xylo
//
//  Created by Lukas Kekys on 13/03/14.
//  Copyright (c) 2014 Seriously. All rights reserved.
//

#import "XYUtils.h"
#import "XYLoginService.h"

@implementation XYUtils

/*+ (void)setupCoreDataStack
{
    BOOL needsLogout = NO;
    
    if (![[[NSUserDefaults standardUserDefaults] objectForKey:@"buildVersion"] isEqualToString: [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]]) {
        NSError *error;
        
        NSLog(@"Old database will be deleted");
        NSString *path = [NSPersistentStore MR_urlForStoreName:@"Xylo.sqlite"].path;
        NSString *previousVersionPath = [NSPersistentStore MR_urlForStoreName:@"CoreDataStore.sqlite"].path;
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:path])
            [[NSFileManager defaultManager] removeItemAtPath:path
                                                       error:&error];
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:previousVersionPath])
            [[NSFileManager defaultManager] removeItemAtPath:previousVersionPath
                                                       error:&error];
        
        [[NSUserDefaults standardUserDefaults] setObject:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"] forKey:@"buildVersion"];
        needsLogout = YES;
    }
    [MagicalRecord setupCoreDataStackWithAutoMigratingSqliteStoreNamed:@"SigningDay.sqlite"];
    
    if (needsLogout) {
        [XYLoginService cleanUpUserSession];
    }
}*/

+ (BOOL)emailFormatValid:(NSString *)email
{
    BOOL result = NO;
    if (email && email.length > 0) {
        
        NSString *emailRegEx =
        @"(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}"
        @"~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"
        @"x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-"
        @"z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5"
        @"]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"
        @"9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"
        @"-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])";
        NSPredicate *regExPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
        result = [regExPredicate evaluateWithObject:email];
    }
    return result;
}

+ (NSDate *)dateFromString:(NSString *)dateString
{
    if (!dateString || [dateString isEqual:[NSNull null]] || [dateString isEqual:@""]) {
        return nil;
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss";
    
    NSDate *date = [dateFormatter dateFromString:dateString];
    
    return date;
}

+ (NSDictionary *)timeLeftFromDate:(NSDate *)date
{
    if (!date) {
        return nil;
    }
    NSString *resultString = nil;
    UIColor *resultColor = nil;
    
    NSDateComponents *todayComponents = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit
                                                                        fromDate:[NSDate date]];
    NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit
                                                                       fromDate:date];
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSTimeInterval timeInterval = [[cal dateFromComponents:todayComponents] timeIntervalSinceDate:[cal dateFromComponents:dateComponents]];
    int daysLeft = timeInterval / 86400; // turning seconds into days
    
    if (timeInterval > 0) {
        
        if (daysLeft > 1) {
            resultString = [NSString stringWithFormat:@"%d days late",daysLeft];
        }
        else {
            resultString = @"Yesterday";
        }
        resultColor = [UIColor colorWithRed:231.0f/255.0f green:109.0f/255.0f blue:102.0f/255.0f alpha:1.0f];
    }
    else {
        if (daysLeft < -1) {
            resultString = [NSString stringWithFormat:@"in %d days",daysLeft*(-1)];
        }
        else if (daysLeft == -1) {
            resultString = @"Tomorrow";
        }
        else {
            resultString = @"Today";
        }
        resultColor = [UIColor colorWithRed:133.0f/255.0f green:161.0f/255.0f blue:165.0f/255.0f alpha:1.0f];
    }
    
    NSMutableDictionary *resultDictionary = [[NSMutableDictionary alloc] init];
    [resultDictionary setObject:resultString forKey:@"resultString"];
    [resultDictionary setObject:resultColor forKey:@"resultColor"];
    
    return resultDictionary;
}

+ (NSString *)formatedDateWithoutHoursStringFromDate:(NSDate *)date
{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:date];
    
    NSInteger year = [components year];
    NSInteger month = [components month];
    NSInteger day = [components day];
    
    NSString *result = [NSString stringWithFormat:@"%lu/%lu/%lu",month,day,year];
    
    return result;
}

+ (NSString *)formatedLocalizedDateStringFromDate:(NSDate *)date
{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSMinuteCalendarUnit | NSHourCalendarUnit | NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:date];
    
    NSInteger year = [components year];
    NSInteger month = [components month];
    NSInteger day = [components day];
    
    NSString * dateString = [NSString stringWithFormat: @"%lu", month];
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM"];
    NSDate* myDate = [dateFormatter dateFromString:dateString];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMMM"];
    NSString *stringFromDate = [formatter stringFromDate:myDate];
    
    
    NSString *result = [NSString stringWithFormat:@"%lu %@ %lu",year,stringFromDate,day];
    
    return result;
}

@end

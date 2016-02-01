//
//  XYErrorService.h
//  xylo
//
//  Created by Lukas Kekys on 17/03/14.
//  Copyright (c) 2014 Seriously. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XYErrorService : NSObject

+ (NSInteger)errorCodeFromError:(NSError *)error;
+ (NSString *)handleRegistrationError:(NSError *)error withDataTask:(NSURLSessionDataTask *)task;

@end

//
//  XYAPIClient.h
//  xylo
//
//  Created by Lukas Kekys on 13/03/14.
//  Copyright (c) 2014 Seriously. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPSessionManager.h"

extern NSString * const kXYAPIClientBaseXyloURLString;
extern NSString * const kXYAPIClientKeychainServiceName;
extern NSString * const kXYAPIClientLogoutNotificationName;

@interface XYAPIClient : AFHTTPSessionManager

@property (nonatomic, assign) BOOL loggedOut;

+ (instancetype)sharedClient;
- (void)logout;

@end

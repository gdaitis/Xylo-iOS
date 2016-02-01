//
//  XYAPIClient.m
//  xylo
//
//  Created by Lukas Kekys on 13/03/14.
//  Copyright (c) 2014 Seriously. All rights reserved.
//

#import "XYAPIClient.h"
#import "XYLoginService.h"
#import <SSKeychain.h>
#import "JSONResponseSerializerWithData.h"

//NSString * const kXYAPIClientBaseXyloURLString = @"http://5f2f3243cc5c4094aeeb8bcfb0ff03da.cloudapp.net/";
NSString * const kXYAPIClientBaseXyloURLString = @"http://dev.xylo.com/";
NSString * const kXYAPIClientKeychainServiceName = @"kXYAPIClientKeychainService";
NSString * const kXYAPIClientLogoutNotificationName = @"kXYAPIClientLogoutNotification";

@interface XYAPIClient () <UIAlertViewDelegate>

@end

@implementation XYAPIClient

+ (instancetype)sharedClient
{
    static XYAPIClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[XYAPIClient alloc] initWithBaseURL:[NSURL URLWithString:kXYAPIClientBaseXyloURLString]];
    });
    
    return _sharedClient;
}

- (id)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    if (self) {
        self.requestSerializer = [AFJSONRequestSerializer serializer];
        [self.requestSerializer setValue:@"XMLHttpRequest" forHTTPHeaderField:@"X-Requested-With"];
        self.responseSerializer = [JSONResponseSerializerWithData serializer];
        
        NSString *username = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
        if (username) {
            NSString *token = [SSKeychain passwordForService:kXYAPIClientKeychainServiceName account:username];
            NSString *authorization = [NSString stringWithFormat:@"Bearer %@", token];
            [self.requestSerializer setValue:authorization forHTTPHeaderField:@"Authorization"];
            
            self.loggedOut = NO;
        } else {
            self.loggedOut = YES;
        }
    }
    
    return self;
}

- (void)logout
{
    if (self.loggedOut)
        return;
    
    self.loggedOut = YES;
    
    NSString *username = [[NSUserDefaults standardUserDefaults] valueForKey:@"username"];
    if (username) {
        [SSKeychain deletePasswordForService:kXYAPIClientKeychainServiceName account:username];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"username"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [[[XYAPIClient sharedClient] requestSerializer] clearAuthorizationHeader];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kXYAPIClientLogoutNotificationName object:nil];
#warning implement the receivers for this notification
}

@end

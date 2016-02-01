//
//  XYGoogleAnalyticsService.m
//  xylo
//
//  Created by Lukas Kekys on 2/26/14.
//  Copyright (c) 2014 Seriously. All rights reserved.
//

#import "XYGoogleAnalyticsService.h"
#import "GAI.h"
#import "GAIDictionaryBuilder.h"
#import "GAIFields.h"

static NSString *const kTrackingId = @"UA-48440539-1";
static NSString *const kAllowTracking = @"allowTracking";

@interface XYGoogleAnalyticsService ()

@property (nonatomic, strong) id<GAITracker> tracker;

@end

@implementation XYGoogleAnalyticsService

+ (id)sharedService
{
    static id sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (void)trackEventWithCategory:(NSString *)category action:(NSString *)action andLabel:(NSString *)label
{
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:category
                                                          action:action
                                                           label:label
                                                           value:nil] build]];
    
}

- (void)trackUXEventWithLabel:(NSString *)label
{
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"UX"
                                                          action:@"touch"
                                                           label:label
                                                           value:nil] build]];
}

- (void)trackAppViewWithName:(NSString *)name
{
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker send:[[[GAIDictionaryBuilder createAppView] set:name
                                                      forKey:kGAIScreenName] build]];
}

- (void)setupService
{
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    [GAI sharedInstance].dispatchInterval = 60;
    
#ifdef DEBUG
    [GAI sharedInstance].dryRun = YES;
    [GAI sharedInstance].optOut = YES;
#else
    [GAI sharedInstance].dryRun = NO;
    [GAI sharedInstance].optOut = NO;
#endif
    //    [[[GAI sharedInstance] logger] setLogLevel:kGAILogLevelVerbose];
    self.tracker = [[GAI sharedInstance] trackerWithTrackingId:kTrackingId];
}


@end

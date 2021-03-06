//
//  NSDictionary+NullConverver.m
//  signingDayPro
//
//  Created by Vytautas Gudaitis on 8/14/13.
//  Copyright (c) 2013 Seriously inc. All rights reserved.
//

#import "NSDictionary+NullConverver.h"

@implementation NSDictionary (NullConverver)

- (NSDictionary *) dictionaryByReplacingNullsWithStrings
{
    const NSMutableDictionary *replaced = [NSMutableDictionary dictionaryWithDictionary: self];
    const id nul = [NSNull null];
    const NSString *blank = @"";
    
    for (NSString *key in self) {
        const id object = [self objectForKey: key];
        if (object == nul) {
            [replaced setObject: blank forKey: key];
        }
        else if ([object isKindOfClass: [NSDictionary class]]) {
            [replaced setObject: [(NSDictionary *) object dictionaryByReplacingNullsWithStrings] forKey: key];
        }
    }
    return [NSDictionary dictionaryWithDictionary: [replaced copy]];
}

@end

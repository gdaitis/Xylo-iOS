//
//  JSONResponseSerializerWithData.h
//  xylo
//
//  Created by Lukas Kekys on 14/03/14.
//  Copyright (c) 2014 Seriously. All rights reserved.
//

#import "AFURLResponseSerialization.h"

/// NSError userInfo key that will contain response data
static NSString * const JSONResponseSerializerWithDataKey = @"JSONResponseSerializerWithDataKey";

@interface JSONResponseSerializerWithData : AFJSONResponseSerializer

@end

//
//  JSONResponseSerializerWithData.m
//  xylo
//
//  Created by Lukas Kekys on 14/03/14.
//  Copyright (c) 2014 Seriously. All rights reserved.
//

#import "JSONResponseSerializerWithData.h"
#import "XYLoginService.h"

@interface JSONResponseSerializerWithData () <UIAlertViewDelegate>

@end

@implementation JSONResponseSerializerWithData

- (id)responseObjectForResponse:(NSHTTPURLResponse *)response
                           data:(NSData *)data
                          error:(NSError *__autoreleasing *)error
{
    NSDictionary *headers = [response allHeaderFields];
    NSString *respondedJSONstring = [headers valueForKey:@"X-Responded-JSON"];
    if (respondedJSONstring) {
        NSDictionary *respondedJSON = [NSJSONSerialization JSONObjectWithData:[respondedJSONstring dataUsingEncoding:NSUTF8StringEncoding]
                                                                      options:NSJSONReadingMutableContainers
                                                                        error:nil];
        NSNumber *statusCode = [respondedJSON valueForKey:@"status"];
        if (statusCode.intValue == 401) {
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                                message:@"Session expired"
                                                               delegate:self
                                                      cancelButtonTitle:@"Ok"
                                                      otherButtonTitles:nil];
                [alert show];
            });
            
            NSError *newError = [[NSError alloc] initWithDomain:@"XyloErrorDomain" code:401 userInfo:nil];
            (*error) = newError;
        }
        
        return (nil);
    }
    
    if (![self validateResponse:(NSHTTPURLResponse *)response data:data error:error]) {
        if (*error != nil) {
            NSMutableDictionary *userInfo = [(*error).userInfo mutableCopy];
            
            userInfo[JSONResponseSerializerWithDataKey] = data;
            NSError *newError = [NSError errorWithDomain:(*error).domain code:(*error).code userInfo:userInfo];
            (*error) = newError;
        }
        
        return (nil);
    }
    
    return ([super responseObjectForResponse:response data:data error:error]);
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [XYLoginService logout];
}

@end

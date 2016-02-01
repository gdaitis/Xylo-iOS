//
//  XYErrorService.m
//  xylo
//
//  Created by Lukas Kekys on 17/03/14.
//  Copyright (c) 2014 Seriously. All rights reserved.
//

#import "XYErrorService.h"
#import "JSONResponseSerializerWithData.h"

@implementation XYErrorService

+ (NSInteger)errorCodeFromError:(NSError *)error
{
    return [[[error userInfo] objectForKey:@"AFNetworkingOperationFailingURLResponseErrorKey"] statusCode];
}

+ (NSString *)handleRegistrationError:(NSError *)error withDataTask:(NSURLSessionDataTask *)task
{
    NSString *errorMessage = nil;
    
    id json = error.userInfo[JSONResponseSerializerWithDataKey];
    if (json) {
        NSLog(@"json = %@",json);
        if ([json isKindOfClass:[NSData class]]) {
//            NSString *dataString = [[NSString alloc] initWithData:json encoding:NSUTF8StringEncoding];
            NSError* error;
            NSDictionary* jsonDictionary = [NSJSONSerialization
                                  JSONObjectWithData:(NSData *)json
                                  
                                  options:kNilOptions 
                                  error:&error];
            
            if ([jsonDictionary valueForKey:@"ModelState"] && [[[jsonDictionary valueForKey:@"ModelState"] class] isSubclassOfClass:[NSDictionary class]]) {
                
                NSDictionary *modelStateDictionary = [jsonDictionary valueForKey:@"ModelState"];
                for (id object in modelStateDictionary) {
                    
                    if ([[object class] isSubclassOfClass:[NSString class]]) {
                        errorMessage = [[modelStateDictionary valueForKey:object] objectAtIndex:0];
                        break;
                    }
                }
            }
            else if ([[[jsonDictionary valueForKey:@"error_description"] class] isSubclassOfClass:[NSString class]]) {
                errorMessage = [json valueForKey:@"error_description"];
            }
        }
    }
    
//    errorMessage = [NSString stringWithString:errorMessage];
    
//    if (errorMessage) {
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:errorMessage delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
//        [alertView show];
//    }
    return errorMessage;
}

@end

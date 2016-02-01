//
//  XYUser+UserFunctions.h
//  xylo
//
//  Created by Lukas Kekys on 07/05/14.
//  Copyright (c) 2014 Seriously. All rights reserved.
//

#import "XYUser.h"

@interface XYUser (UserFunctions)

+ (XYUser *)updateUserFromResponse:(id)response;
+ (BOOL)masterUserBelongsToEnsemble:(XYEnsemble *)ensemble;
+ (XYUser *)masterUser;
+ (XYUser *)masterUserInContext:(NSManagedObjectContext *)context;

@end

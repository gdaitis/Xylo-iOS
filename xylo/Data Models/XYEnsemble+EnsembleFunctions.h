//
//  XYEnsemble+EnsembleFunctions.h
//  xylo
//
//  Created by Lukas Kekys on 28/04/14.
//  Copyright (c) 2014 Seriously. All rights reserved.
//

#import "XYEnsemble.h"

@interface XYEnsemble (EnsembleFunctions)

+ (void)updateEnsemblesFromResponse:(id)response
                    forOrganization:(XYOrganization *)parentOrganization
                          inContext:(NSManagedObjectContext *)context;
- (NSArray *)usersSortedByName;

@end

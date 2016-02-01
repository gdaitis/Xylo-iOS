//
//  UIView+viewRecursion.m
//  xylo
//
//  Created by lite on 30/05/14.
//  Copyright (c) 2014 Seriously. All rights reserved.
//

#import "UIView+viewRecursion.h"

@implementation UIView (viewRecursion)

- (NSMutableArray *)allSubViews
{
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    [arr addObject:self];
    for (UIView *subview in self.subviews) {
        [arr addObjectsFromArray:(NSArray*)[subview allSubViews]];
    }
    return arr;
}

@end

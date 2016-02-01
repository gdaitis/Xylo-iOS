//
//  XYTaskViewController.h
//  xylo
//
//  Created by Lukas Kekys on 02/09/14.
//  Copyright (c) 2014 Seriously. All rights reserved.
//

#import "XYBaseLoggedInViewController.h"

@class XYTask;

@interface XYTaskViewController : XYBaseLoggedInViewController

@property (nonatomic, strong) XYTask *currentTask;

@end

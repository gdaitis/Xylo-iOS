//
//  XYNewPasswordViewController.h
//  xylo
//
//  Created by lite on 02/06/14.
//  Copyright (c) 2014 Seriously. All rights reserved.
//

#import "XYPasswordResetViewController.h"

extern NSString * const XYPasswordResetViewControllerTokenNotification;

@interface XYNewPasswordViewController : XYPasswordResetViewController

@property (nonatomic, strong) NSString *token;

@end

//
//  XYLoginViewController.h
//  xylo
//
//  Created by Lukas Kekys on 27/06/14.
//  Copyright (c) 2014 Seriously. All rights reserved.
//

#import "XYBaseViewController.h"

@class XYLoginViewController;

@protocol XYLoginViewControllerDelegate <NSObject>

@optional

- (void)loginViewControllerDidLogIn:(XYLoginViewController *)loginViewController;

@end

@interface XYLoginViewController : XYBaseViewController

@property (nonatomic, weak) id <XYLoginViewControllerDelegate> delegate;

@end

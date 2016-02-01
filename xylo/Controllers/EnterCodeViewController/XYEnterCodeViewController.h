//
//  XYEnterCodeViewController.h
//  xylo
//
//  Created by Lukas Kekys on 03/03/14.
//  Copyright (c) 2014 Seriously. All rights reserved.
//

#import "XYBaseViewController.h"

@class XYEnterCodeViewController;

@protocol XYEnterCodeViewControllerDelegate <NSObject>

@optional

- (void)enterCodeViewControllerDidLogIn:(XYEnterCodeViewController *)enterCodeViewController;

@end

@interface XYEnterCodeViewController : XYBaseViewController

@property (nonatomic, weak) id <XYEnterCodeViewControllerDelegate> delegate;

@end

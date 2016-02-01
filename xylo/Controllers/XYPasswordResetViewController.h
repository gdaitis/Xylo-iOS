//
//  XYPasswordResetViewController.h
//  xylo
//
//  Created by lite on 30/05/14.
//  Copyright (c) 2014 Seriously. All rights reserved.
//

#import "XYBaseViewController.h"
#import "XYRegistrationNextButton.h"

@interface XYPasswordResetViewController : XYBaseViewController

@property (nonatomic, strong) XYTextField *firstTextField;
@property (nonatomic, strong) XYTextField *secondTextField;
@property (nonatomic, strong) UILabel *noticeLabel;
@property (nonatomic, strong) XYRegistrationNextButton *nextButton;

- (void)setupTexts;
- (void)nextButtonPressed;
- (void)backButtonPressed;

@end

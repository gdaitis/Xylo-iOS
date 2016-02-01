//
//  XYRegistrationNextButton.h
//  xylo
//
//  Created by lite on 03/03/14.
//  Copyright (c) 2014 Seriously. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XYRegistrationNextButton : UIButton

@property (nonatomic, strong) NSLayoutConstraint *topConstraint;

@property (assign) BOOL pulsating;
@property (assign) BOOL loading;

- (void)startPulsating;
- (void)pausePulsating;
- (void)startLoadingIndicator;
- (void)pauseLoadingIndicator;
- (void)changeToYesButton;
- (void)changeToSelectButton;
- (void)changeToNextButton;

@end

//
//  XYBaseViewController.h
//  xylo
//
//  Created by Lukas Kekys on 2/24/14.
//  Copyright (c) 2014 Seriously. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYTextField.h"

@interface XYBaseViewController : UIViewController <XYTextFieldDelegate>

@property (nonatomic, assign) BOOL trackKeyboard;
@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;



- (void)keyboardWasShown:(NSNotification *)notification;  //overide these functions in subclasses for custom behaviour
- (void)keyboardWillHide:(NSNotification *)notification;
- (void)showAlertWithTitle:(NSString *)title andErrorMessage:(NSString *)errorMessage;
- (void)showProgressHudInView:(UIView *)view withText:(NSString *)text;
- (void)hideProgressHudInView:(UIView *)view;

@end

//
//  XYNewPasswordViewController.m
//  xylo
//
//  Created by lite on 02/06/14.
//  Copyright (c) 2014 Seriously. All rights reserved.
//

#import "XYNewPasswordViewController.h"
#import "XYLoginService.h"

NSString * const XYPasswordResetViewControllerTokenNotification = @"XYPasswordResetViewControllerTokenNotificationName";

@interface XYNewPasswordViewController ()

@end

@implementation XYNewPasswordViewController

- (void)setupTexts
{
    NSString *newPasswordString = @"New password";
    UIColor *placeholderColor = [UIColor colorWithRed:139.0f/255.0f green:160.0f/255.0f blue:165.0f/255.0f alpha:1];
    self.firstTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:newPasswordString
                                                                                attributes:@{NSForegroundColorAttributeName:placeholderColor}];
    
    NSString *confirmNewPasswordString = @"Confirm new password";
    self.secondTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:confirmNewPasswordString
                                                                                 attributes:@{NSForegroundColorAttributeName:placeholderColor}];
    
    NSString *newPasswordNoticeText = @"Please enter your new password";
    self.noticeLabel.text = newPasswordNoticeText;
}

- (void)nextButtonPressed
{
    [self.nextButton pausePulsating];
    [self.nextButton startLoadingIndicator];
    if ([self.firstTextField.text isEqualToString:self.secondTextField.text]) {
        [self.nextButton startLoadingIndicator];
        [XYLoginService resetPasswordForToken:self.token
                                  newPassword:self.firstTextField.text
                              confirmPassword:self.secondTextField.text
                                 successBlock:^{
                                     [self.nextButton pauseLoadingIndicator];
                                     [self.navigationController popToRootViewControllerAnimated:YES];
                                     NSString *passwordChangedAlertTextString = @"The password was changed, you not may log in";
                                     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                                                     message:passwordChangedAlertTextString
                                                                                    delegate:nil
                                                                           cancelButtonTitle:@"Ok"
                                                                           otherButtonTitles:nil];
                                     [alert show];
                                 }
                                 failureBlock:^{
                                     [self.nextButton pauseLoadingIndicator];
                                     NSString *serverErrorTextString = @"Server error";
                                     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                                                     message:serverErrorTextString
                                                                                    delegate:nil
                                                                           cancelButtonTitle:@"Ok"
                                                                           otherButtonTitles:nil];
                                     [alert show];
                                 }];
    } else {
        NSString *emailsMissmatchErrorString = @"The passwords entered do not match";
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:emailsMissmatchErrorString
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

- (void)backButtonPressed
{
    [super backButtonPressed];
}

@end

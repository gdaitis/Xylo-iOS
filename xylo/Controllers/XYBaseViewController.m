//
//  XYBaseViewController.m
//  xylo
//
//  Created by Lukas Kekys on 2/24/14.
//  Copyright (c) 2014 Seriously. All rights reserved.
//

#import "XYBaseViewController.h"
#import "UIView+viewRecursion.h"
#import "MBProgressHUD.h"

#define kOffsetFromTextFieldAndKeyboard 20

@interface XYBaseViewController ()

@end

@implementation XYBaseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    // Setup navigation bar appearance
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:29.0f/255.0f green:33.0f/255.0f blue:35.0f/255.0f alpha:1.0f]];
    self.navigationController.navigationBar.translucent = NO;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor colorWithRed:49.0f/255.0f green:56.0f/255.0f blue:60.0f/255.0f alpha:1.0f];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.trackKeyboard) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (self.trackKeyboard) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    }
}

- (void)showProgressHudInView:(UIView *)view withText:(NSString *)text
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    if (text) {
        hud.labelText = text;
    }
}

- (void)hideProgressHudInView:(UIView *)view
{
    [MBProgressHUD hideAllHUDsForView:view animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)showAlertWithTitle:(NSString *)title andErrorMessage:(NSString *)errorMessage
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:errorMessage delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
}

#pragma mark - Keyboard presentation

- (void)keyboardWasShown:(NSNotification *)notification
{
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.scrollView addGestureRecognizer:gestureRecognizer];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    
    [UIView animateWithDuration:0.25f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.scrollView.contentOffset = CGPointZero;
    } completion:^(__unused BOOL finished) {
        if (self.scrollView.gestureRecognizers) {
            for (UIGestureRecognizer *gestureRecognizer in self.scrollView.gestureRecognizers) {
                if ([[gestureRecognizer class] isSubclassOfClass:[UITapGestureRecognizer class]]) {
                    [self.scrollView removeGestureRecognizer:gestureRecognizer];
                    break;
                }
            }
        }
    }];
}

- (void)dismissKeyboard
{
    for (UIView *view in [self.view allSubViews]) {
        if ([view respondsToSelector:@selector(resignFirstResponder)]) {
            [view resignFirstResponder];
        }
    }
}

#pragma mark - XYTextFieldView delegate

- (void)textFieldBecameActive:(XYTextField *)textField
{
    if (textField.frame.origin.y + textField.frame.size.height > self.view.frame.size.height - kDefaultKeyboardHeight - kOffsetFromTextFieldAndKeyboard) {
        
        [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
            int buttonDifference = (textField.frame.origin.y + textField.frame.size.height ) - (self.view.frame.size.height - kDefaultKeyboardHeight - kOffsetFromTextFieldAndKeyboard);
            self.scrollView.contentOffset = CGPointMake(0, buttonDifference);
        } completion:^(__unused BOOL finished) {
        }];
    }
    else
    {
        [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.scrollView.contentOffset = CGPointZero;
        } completion:^(__unused BOOL finished) {
        }];
    }
}

- (void)textFieldBecameInactive:(XYTextField *)textField
{
    
}

@end

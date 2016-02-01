//
//  XYPasswordResetViewController.m
//  xylo
//
//  Created by lite on 30/05/14.
//  Copyright (c) 2014 Seriously. All rights reserved.
//

#import "XYPasswordResetViewController.h"
#import "XYLoginService.h"

@interface XYPasswordResetViewController () <XYTextFieldDelegate>

@end

@implementation XYPasswordResetViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.trackKeyboard = YES;
        [self.navigationController setNavigationBarHidden:YES animated:NO];
        
        // scrollView
        self.scrollView = [UIScrollView newAutoLayoutView];
        [self.view addSubview:self.scrollView];
        
        [self.scrollView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
        
        // logo
        UIImage *xyloLogo = [[UIImage imageNamed:@"xyloBetaLogo"] imageWithAlignmentRectInsets:UIEdgeInsetsMake(0, 0, 0, 15)];
        UIImageView *xyloLogoImageView = [[UIImageView alloc] initWithImage:xyloLogo];
        xyloLogoImageView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.scrollView addSubview:xyloLogoImageView];
        
        [xyloLogoImageView autoAlignAxisToSuperviewAxis:ALAxisVertical];
        [xyloLogoImageView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:[UIScreen mainScreen].bounds.size.height > 480.0f ? 57 : 47];
        
        // bottom
        UIImage *registrationFooter = [UIImage imageNamed:@"registrationFooter"];
        UIImageView *registrationFooterImageView = [[UIImageView alloc] initWithImage:registrationFooter];
        registrationFooterImageView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.view addSubview:registrationFooterImageView];
        
        [registrationFooterImageView autoAlignAxisToSuperviewAxis:ALAxisVertical];
        [registrationFooterImageView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0];
        
        // text fields
        self.firstTextField = [XYTextField newAutoLayoutView];
        self.firstTextField.xyTextFieldDelegate = self;
        self.firstTextField.returnKeyType = UIReturnKeyNext;
        self.firstTextField.font = [UIFont fontWithName:@"OpenSans" size:15];
        [self.scrollView addSubview:self.firstTextField];
        
        [self.firstTextField autoSetDimensionsToSize:CGSizeMake(200, 40)];
        [self.firstTextField autoAlignAxisToSuperviewAxis:ALAxisVertical];
        [self.firstTextField autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:xyloLogoImageView withOffset:118];
        
        self.secondTextField = [XYTextField newAutoLayoutView];
        self.secondTextField.xyTextFieldDelegate = self;
        self.secondTextField.font = [UIFont fontWithName:@"OpenSans" size:15];
        [self.scrollView addSubview:self.secondTextField];
        
        [self.secondTextField autoSetDimensionsToSize:CGSizeMake(200, 40)];
        [self.secondTextField autoAlignAxisToSuperviewAxis:ALAxisVertical];
        [self.secondTextField autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.firstTextField withOffset:15];
        
        // notice label
        self.noticeLabel = [UILabel newAutoLayoutView];
        self.noticeLabel.font = [UIFont fontWithName:@"OpenSans" size:15];
        self.noticeLabel.textColor = [UIColor whiteColor];
        self.noticeLabel.textAlignment = NSTextAlignmentCenter;
        self.noticeLabel.numberOfLines = 0;
        self.noticeLabel.preferredMaxLayoutWidth = 264;
        [self.scrollView addSubview:self.noticeLabel];
        
        [self.noticeLabel autoAlignAxisToSuperviewAxis:ALAxisVertical];
        [self.noticeLabel autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:self.firstTextField withOffset:-18];
        
        // next button
        self.nextButton = [XYRegistrationNextButton newAutoLayoutView];
        [self.nextButton addTarget:self action:@selector(nextButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        [self.nextButton changeToNextButton];
        [self.scrollView addSubview:self.nextButton];
        
        [self.nextButton autoSetDimensionsToSize:CGSizeMake(72, 72)];
        [self.nextButton autoAlignAxisToSuperviewAxis:ALAxisVertical];
        [self.nextButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.secondTextField withOffset:[UIScreen mainScreen].bounds.size.height > 480.0f ? 30 : 20];
        
        // back button
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        backButton.backgroundColor = [UIColor clearColor];
        [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        NSString *backString = @"Back";
        [backButton setTitle:backString forState:UIControlStateNormal];
        backButton.titleLabel.font = [UIFont fontWithName:@"OpenSans" size:13];
        backButton.translatesAutoresizingMaskIntoConstraints = NO;
        [backButton addTarget:self action:@selector(backButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollView addSubview:backButton];
        
        [backButton autoAlignAxisToSuperviewAxis:ALAxisVertical];
        [backButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.nextButton withOffset:[UIScreen mainScreen].bounds.size.height > 480.0f ? 40 : 15];
        
        [self setupTexts];
    }
    return self;
}

- (void)setupTexts
{
    NSString *emailString = @"Email";
    UIColor *placeholderColor = [UIColor colorWithRed:139.0f/255.0f green:160.0f/255.0f blue:165.0f/255.0f alpha:1];
    self.firstTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:emailString
                                                                                attributes:@{NSForegroundColorAttributeName:placeholderColor}];
    
    NSString *confirmEmailString = @"Confirm email";
    self.secondTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:confirmEmailString
                                                                                 attributes:@{NSForegroundColorAttributeName:placeholderColor}];
    
    NSString *forgotPasswordNoticeText = @"Please enter the email address you used when you created your account, and we will send you an email with further instructions.";
    self.noticeLabel.text = forgotPasswordNoticeText;
}

- (void)nextButtonPressed
{
    [self.nextButton pausePulsating];
    
    if ([self.firstTextField.text isEqualToString:self.secondTextField.text]) {
        if (self.firstTextField.text) {
            [self.nextButton startLoadingIndicator];
            [XYLoginService forgotPasswordForEmail:self.firstTextField.text
                                      successBlock:^{
                                          [self.nextButton pauseLoadingIndicator];
                                          
                                          NSString *noticeString = @"We have sent a password reset request if the email is verified";
                                          UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                                                          message:noticeString
                                                                                         delegate:nil
                                                                                cancelButtonTitle:@"Ok"
                                                                                otherButtonTitles:nil];
                                          [alert show];
                                          
                                          [self.navigationController popViewControllerAnimated:YES];
                                      } failureBlock:^{
                                          [self.nextButton pauseLoadingIndicator];
                                      }];
        } else {
            NSString *emailsMissmatchErrorString = @"Please enter the email";
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                            message:emailsMissmatchErrorString
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
            [alert show];
        }
        
    } else {
        NSString *emailsMissmatchErrorString = @"The emails entered do not match";
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
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - XYTextFieldView delegate

- (void)returnButtonSelectedInTextField:(XYTextField *)textField
{
    [textField resignFirstResponder];
    if (textField == self.firstTextField) {
        [self.secondTextField becomeFirstResponder];
    }
    
    if ([self.firstTextField hasText] && [self.secondTextField hasText]) {
        [self.nextButton startPulsating];
    }
}


@end

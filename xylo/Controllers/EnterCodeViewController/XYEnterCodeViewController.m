//
//  XYEnterCodeViewController.m
//  xylo
//
//  Created by Lukas Kekys on 03/03/14.
//  Copyright (c) 2014 Seriously. All rights reserved.
//

#import "XYEnterCodeViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "XYRegistrationNextButton.h"
#import "XYTextField.h"
#import "XYLoginService.h"
#import "XYOrganization.h"
#import "XYPersonalInformationViewController.h"
#import "XYPasswordResetViewController.h"
#import "XYNewPasswordViewController.h"

// TODO: delete this
#import "XYRootViewController.h"

#define kXYEnterCodeViewControllerTopConstraintConstantOfConfirmMode [UIScreen mainScreen].bounds.size.height > 480.0f ? 57 : 47
#define kXYEnterCodeViewControllerTopConstraintDefaultConstant [UIScreen mainScreen].bounds.size.height > 480.0f ? 131 : 88
#define kXYEnterCodeViewControllerOffscreenOffset 320
#define kXYEnterCodeViewControllerNextButtonConstraintDeltaInLoginStage [UIScreen mainScreen].bounds.size.height > 480.0f ? 0 : 5

NSString * const kXYEnterCodeViewControllerEnterYourCodeString = @"Enter your code";
NSString * const kXYEnterCodeViewControllerLoginButtonTitle = @"Have an Account? Login";
NSString * const kXYEnterCodeViewControllerCodeRegisterButtonTitle = @"Enter your Code & Register";
NSString * const kXYEnterCodeViewControllerPasswordString = @"Password";
NSString * const kXYEnterCodeViewControllerSorryBadCodeString = @"Sorry, bad code";

@interface XYEnterCodeViewController () <UITextFieldDelegate>

@property (nonatomic, strong) XYOrganization *currentOrganization;
@property (assign) BOOL badCodeEnteredState;
@property (nonatomic, weak) IBOutlet XYRegistrationNextButton *nextButton;
@property (weak, nonatomic) IBOutlet UIButton *bottomButton;
@property (weak, nonatomic) IBOutlet UIImageView *xyloLogoImageView;
@property (weak, nonatomic) IBOutlet UIImageView *bottomImageView;
@property (nonatomic, strong) XYTextField *firstTextField;
@property (weak, nonatomic) IBOutlet XYTextField *secondTextField;
@property (nonatomic, strong) UILabel *orLabel;
@property (nonatomic, strong) UIButton *noButton;
@property (nonatomic, strong) UILabel *badCodeLabel;
@property (nonatomic, strong) UILabel *firstNoticeLabel;
@property (nonatomic, strong) UILabel *secondNoticeLabel;
@property (nonatomic, strong) UIButton *forgotPasswordButton;
@property (assign) CGRect originalBadCodeLabelFrame;
@property (assign) CGRect originalNextButtonFrame;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *nextButtonXConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *nextButtonYConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *bottomButtonYConstraint;
@property (nonatomic, strong) NSLayoutConstraint *noButtonXConstraint;
@property (nonatomic, strong) NSLayoutConstraint *noButtonYConstraint;
@property (nonatomic, strong) NSLayoutConstraint *orLabelXConstraint;
@property (nonatomic, strong) NSLayoutConstraint *orLabelYConstraint;
@property (nonatomic, strong) NSLayoutConstraint *secondNoticeLabelXConstraint;
@property (nonatomic, strong) NSLayoutConstraint *secondNoticeLabelYConstraint;
@property (nonatomic, strong) NSLayoutConstraint *firstNoticeLabelXConstraint;
@property (nonatomic, strong) NSLayoutConstraint *firstNoticeLabelYConstraint;
@property (nonatomic, strong) NSLayoutConstraint *newNextButtonYConstraint;
@property (nonatomic, strong) NSLayoutConstraint *newBottomButtonYConstraint;
@property (nonatomic, strong) NSLayoutConstraint *badCodeLabelXConstraint;
@property (nonatomic, strong) NSLayoutConstraint *badCodeLabelYConstraint;
@property (nonatomic, strong) NSLayoutConstraint *forgotPasswordButtonXConstraint;
@property (nonatomic, strong) NSLayoutConstraint *forgotPasswordButtonYConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *secondTextFieldYConstraint;
@property (nonatomic, strong) NSLayoutConstraint *firstTextFieldXConstraint;
@property (nonatomic, strong) NSLayoutConstraint *firstTextFieldYConstraint;
@property (nonatomic, strong) NSLayoutConstraint *newSecondTextFieldYConstraint;

@end

@implementation XYEnterCodeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(tokenNotificationReceived:)
                                                 name:XYPasswordResetViewControllerTokenNotification
                                               object:nil];
    
    self.topConstraint.constant = kXYEnterCodeViewControllerTopConstraintDefaultConstant;
    
    UIGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                              action:@selector(closeKeyboard)];
    [self.view addGestureRecognizer:recognizer];
    
    [self.view addSubview:self.badCodeLabel];
    [self.view addConstraint:self.badCodeLabelXConstraint];
    [self.view addConstraint:self.badCodeLabelYConstraint];
    [self.view layoutIfNeeded];
    
    self.navigationController.navigationBarHidden = YES;
    
    self.badCodeEnteredState = NO;
    
    self.secondTextField.font = [UIFont fontWithName:@"OpenSans" size:15];
    
    self.secondTextField.delegate = self;
    
    NSString *enterYourCodeString = kXYEnterCodeViewControllerEnterYourCodeString;
    UIColor *placeholderColor = [UIColor colorWithRed:139.0f/255.0f green:160.0f/255.0f blue:165.0f/255.0f alpha:1];
    self.secondTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:enterYourCodeString
                                                                                 attributes:@{NSForegroundColorAttributeName: placeholderColor}];
    
    self.bottomButton.backgroundColor = [UIColor colorWithRed:29.0f/255.0f green:33.0f/255.0f blue:35.0f/255.0f alpha:1.0f];
    NSString *loginButtonTitle = kXYEnterCodeViewControllerLoginButtonTitle;
    [self.bottomButton setTitle:loginButtonTitle
                       forState:UIControlStateNormal];
    [self.bottomButton setTitleColor:[UIColor whiteColor]
                            forState:UIControlStateNormal];
    self.bottomButton.titleLabel.font = [UIFont fontWithName:@"OpenSans" size:15];
}

- (void)updateViewConstraints
{
    [super updateViewConstraints];
    
    
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    self.originalBadCodeLabelFrame = self.badCodeLabel.frame;
    self.originalNextButtonFrame = self.nextButton.frame;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:XYPasswordResetViewControllerTokenNotification
                                                  object:nil];
}


- (void)tokenNotificationReceived:(NSNotification *)notiication
{
    NSString *token = [[notiication userInfo] valueForKey:@"token"];
    XYNewPasswordViewController *newPasswordViewController = [XYNewPasswordViewController new];
    newPasswordViewController.token = token;
    [self.navigationController pushViewController:newPasswordViewController animated:YES];
}

#pragma mark - Button methods

- (void)closeKeyboard
{
    [self.firstTextField resignFirstResponder];
    [self.secondTextField resignFirstResponder];
    
    if (self.badCodeEnteredState)
        [self toggleErrorStageWithMessage:nil];
}

- (IBAction)nextButtonPressedFromEnterCodeStage
{
    [self closeKeyboard];
    
    NSString *enteredCode = self.secondTextField.text;
    
    [self.nextButton startLoadingIndicator];
    self.bottomButton.userInteractionEnabled = NO;
    [XYLoginService checkCodeWithCodeString:enteredCode
                               successBlock:^(XYOrganization *organization, XYLoginServiceCodeCheckError codeCheckError) {
                                   
                                   self.currentOrganization = organization;
                                   [self switchToConfirmModeWithOrganisationName:organization.name];
                                   self.bottomButton.userInteractionEnabled = YES;
                               } failureBlock:^{
                                   self.currentOrganization = nil;
                                   [self.nextButton pauseLoadingIndicator];
                                   [self toggleErrorStageWithMessage:kXYEnterCodeViewControllerSorryBadCodeString];
                                   self.bottomButton.userInteractionEnabled = YES;
                               }];
}

- (void)nextButtonPressedFromLoginStage
{
    NSString *username = self.firstTextField.text;
    NSString *password = self.secondTextField.text;
    
    [self.nextButton startLoadingIndicator];
    
    [XYLoginService loginUserWithEmail:username
                              password:password
                          successBlock:^ {
                              [self.nextButton pauseLoadingIndicator];
                              
                              [self.delegate enterCodeViewControllerDidLogIn:self];
                          } failureBlock:^{
                              [self.nextButton pauseLoadingIndicator];
                              
                              NSString *badLoginString = @"Sorry, bad email or password";
                              [self toggleErrorStageWithMessage:badLoginString];
                          }];
}

- (IBAction)loginButtonPressed
{
    //[self switchToConfirmModeWithOrganisationName:@"BD Performing Arts BD Performing Arts"];
    //[self toggleBadCodeEnteredState];
    
    [self switchToLoginStage];
}

- (void)codeRegisterButtonPressed
{
    [self rollbackToInitialStageFromLoginStage];
}

- (void)noButtonSelected
{
    [self rollBackToInitialEnterCodeStageFromConfrimationStage];
}

- (void)yesButtonSelected
{
    XYPersonalInformationViewController *personalInformationController = [[XYPersonalInformationViewController alloc] init];
    personalInformationController.organizationId = self.currentOrganization.organizationID;
    [self.navigationController pushViewController:personalInformationController
                                         animated:YES];
}

- (void)forgotPasswordPressed
{
    XYPasswordResetViewController *passwordResetViewController = [[XYPasswordResetViewController alloc] init];
    [self.navigationController pushViewController:passwordResetViewController animated:YES];
}

#pragma mark - Switching stages

- (void)switchToLoginStage
{
    self.firstTextField.text = @"";
    self.firstTextField.returnKeyType = UIReturnKeyNext;
    self.firstTextField.keyboardType = UIKeyboardTypeEmailAddress;
    self.secondTextField.text = @"";
    self.secondTextField.secureTextEntry = YES;
    self.secondTextField.returnKeyType = UIReturnKeyDone;
    
    [self.bottomButton removeTarget:self
                             action:@selector(loginButtonPressed)
                   forControlEvents:UIControlEventTouchUpInside];
    [self.bottomButton addTarget:self
                          action:@selector(codeRegisterButtonPressed)
                forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.firstTextField];
    self.firstTextField.alpha = 0;
    [self.view addConstraints:@[self.firstTextFieldXConstraint, self.firstTextFieldYConstraint]];
    NSString *emailString = @"E-mail";
    UIColor *placeholderColor = [UIColor colorWithRed:139.0f/255.0f
                                                green:160.0f/255.0f
                                                 blue:165.0f/255.0f
                                                alpha:1];
    self.firstTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:emailString
                                                                                attributes:@{NSForegroundColorAttributeName: placeholderColor}];
    
    [self.forgotPasswordButton addTarget:self
                                  action:@selector(forgotPasswordPressed)
                        forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.forgotPasswordButton];
    self.forgotPasswordButton.alpha = 0;
    [self.view addConstraints:@[self.forgotPasswordButtonXConstraint, self.forgotPasswordButtonYConstraint]];
    
    [self.view layoutIfNeeded];
    
    [UIView animateWithDuration:0.2
                     animations:^{
                         
                         self.secondTextField.alpha = 0;
                         self.bottomButton.titleLabel.alpha = 0;
                         
                     } completion:^(BOOL finished) {
                         
                         if (finished) {
                             
                             NSString *codeRegisterButtonTitle = kXYEnterCodeViewControllerCodeRegisterButtonTitle;
                             [self.bottomButton setTitle:codeRegisterButtonTitle
                                                forState:UIControlStateNormal];
                             
                             [self.view layoutIfNeeded];
                             
                             NSString *passwordString = kXYEnterCodeViewControllerPasswordString;
                             UIColor *placeholderColor = [UIColor colorWithRed:139.0f/255.0f
                                                                         green:160.0f/255.0f
                                                                          blue:165.0f/255.0f
                                                                         alpha:1];
                             self.secondTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:passwordString
                                                                                                          attributes:@{NSForegroundColorAttributeName: placeholderColor}];
                             
                             [self.nextButton removeTarget:self
                                                    action:@selector(nextButtonPressedFromEnterCodeStage)
                                          forControlEvents:UIControlEventTouchUpInside];
                             [self.nextButton addTarget:self
                                                 action:@selector(nextButtonPressedFromLoginStage)
                                       forControlEvents:UIControlEventTouchUpInside];
                             [self.nextButton pausePulsating];
                             
                             self.topConstraint.constant = kXYEnterCodeViewControllerTopConstraintConstantOfConfirmMode;
                             self.nextButtonYConstraint.constant -= kXYEnterCodeViewControllerNextButtonConstraintDeltaInLoginStage;
                             
                             [self.view removeConstraint:self.secondTextFieldYConstraint];
                             [self.view addConstraint:self.newSecondTextFieldYConstraint];
                             
                             [UIView animateWithDuration:0.2
                                              animations:^{
                                                  self.forgotPasswordButton.alpha = 1;
                                                  self.firstTextField.alpha = 1;
                                                  self.secondTextField.alpha = 1;
                                                  self.bottomButton.titleLabel.alpha = 1;
                                                  
                                                  [self.view layoutIfNeeded];
                                              } completion:nil];
                         }
                     }];
}

- (void)rollbackToInitialStageFromLoginStage
{
    self.firstTextField.text = @"";
    self.firstTextField.returnKeyType = UIReturnKeyNext;
    self.firstTextField.keyboardType = UIKeyboardTypeEmailAddress;
    self.secondTextField.text = @"";
    self.secondTextField.secureTextEntry = NO;
    self.secondTextField.returnKeyType = UIReturnKeyDone;
    
    if (self.badCodeEnteredState)
        [self toggleErrorStageWithMessage:nil];
    
    [self.view layoutIfNeeded];
    
    [UIView animateWithDuration:0.2
                     animations:^{
                         
                         self.firstTextField.alpha = 0;
                         self.secondTextField.alpha = 0;
                         self.bottomButton.titleLabel.alpha = 0;
                         self.forgotPasswordButton.alpha = 0;
                         
                     } completion:^(BOOL finished) {
                         
                         NSString *loginButtonTitle = kXYEnterCodeViewControllerLoginButtonTitle;
                         [self.bottomButton setTitle:loginButtonTitle
                                            forState:UIControlStateNormal];
                         [self.view layoutIfNeeded];
                         
                         self.topConstraint.constant = kXYEnterCodeViewControllerTopConstraintDefaultConstant;
                         self.nextButtonYConstraint.constant += kXYEnterCodeViewControllerNextButtonConstraintDeltaInLoginStage;
                         
                         [self.firstTextField removeFromSuperview];
                         [self.forgotPasswordButton removeFromSuperview];
                         [self.view removeConstraint:self.newSecondTextFieldYConstraint];
                         [self.view addConstraint:self.secondTextFieldYConstraint];
                         
                         [self.bottomButton removeTarget:self
                                                  action:@selector(codeRegisterButtonPressed)
                                        forControlEvents:UIControlEventTouchUpInside];
                         [self.bottomButton addTarget:self
                                               action:@selector(loginButtonPressed)
                                     forControlEvents:UIControlEventTouchUpInside];
                         
                         UIColor *placeholderColor = [UIColor colorWithRed:139.0f/255.0f
                                                                     green:160.0f/255.0f
                                                                      blue:165.0f/255.0f
                                                                     alpha:1];
                         self.secondTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:kXYEnterCodeViewControllerEnterYourCodeString
                                                                                                      attributes:@{NSForegroundColorAttributeName: placeholderColor}];
                         
                         [self.nextButton removeTarget:self
                                                action:@selector(nextButtonPressedFromLoginStage)
                                      forControlEvents:UIControlEventTouchUpInside];
                         [self.nextButton addTarget:self
                                             action:@selector(nextButtonPressedFromEnterCodeStage)
                                   forControlEvents:UIControlEventTouchUpInside];
                         [self.nextButton pausePulsating];
                         
                         [UIView animateWithDuration:0.2
                                          animations:^{
                                              
                                              self.secondTextField.alpha = 1;
                                              self.bottomButton.titleLabel.alpha = 1;
                                              
                                              [self.view layoutIfNeeded];
                                              
                                          } completion:nil];
                         
                     }];
}

- (void)toggleErrorStageWithMessage:(NSString *)errorMessage
{
    [self.nextButton pausePulsating];
    
    if (!self.badCodeEnteredState) {
        
        self.badCodeLabel.text = errorMessage;
        
        self.badCodeLabel.hidden = NO;
        
        self.badCodeLabelXConstraint.constant +=kXYEnterCodeViewControllerOffscreenOffset;
        self.nextButtonXConstraint.constant -=kXYEnterCodeViewControllerOffscreenOffset;
        
        [UIView animateWithDuration:0.2
                         animations:^{
                             
                             [self.view layoutIfNeeded];
                             self.view.backgroundColor = [UIColor colorWithRed:196.0f/255.0f green:90.0f/255.0f blue:32.0f/255.0f alpha:1.0f];
                             
                             if ([self.forgotPasswordButton superview])
                                 self.forgotPasswordButton.alpha = 0;
                             
                         } completion:nil];
        
        self.badCodeEnteredState = YES;
        
    } else {
        
        self.badCodeLabelXConstraint.constant -=kXYEnterCodeViewControllerOffscreenOffset;
        self.nextButtonXConstraint.constant +=kXYEnterCodeViewControllerOffscreenOffset;
        
        [UIView animateWithDuration:0.2
                         animations:^{
                             
                             [self.view layoutIfNeeded];
                             self.view.backgroundColor = [UIColor colorWithRed:49.0f/255.0f green:56.0f/255.0f blue:60.0f/255.0f alpha:1.0f];
                             
                             if ([self.forgotPasswordButton superview])
                                 self.forgotPasswordButton.alpha = 1;
                             
                         } completion:nil];
        
        self.badCodeEnteredState = NO;
        
    }
}

- (void)switchToConfirmModeWithOrganisationName:(NSString *)organisationName
{
    
    [self.noButton addTarget:self
                      action:@selector(noButtonSelected)
            forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.noButton];
    self.noButton.alpha = 0;
    [self.view addConstraints:@[self.noButtonXConstraint, self.noButtonYConstraint]];
    
    [self.view addSubview:self.orLabel];
    self.orLabel.alpha = 0;
    [self.view addConstraints:@[self.orLabelXConstraint, self.orLabelYConstraint]];
    
    
    NSString *noticeString = @"Is that your organisation?";
    self.secondNoticeLabel.text = noticeString;
    [self.view addSubview:self.secondNoticeLabel];
    self.secondNoticeLabel.alpha = 0;
    [self.view addConstraints:@[self.secondNoticeLabelXConstraint, self.secondNoticeLabelYConstraint]];
    
    self.firstNoticeLabel.text = organisationName;
    
    self.firstNoticeLabel.alpha = 0;
    [self.view addSubview:self.firstNoticeLabel];
    [self.view addConstraints:@[self.firstNoticeLabelXConstraint, self.firstNoticeLabelYConstraint]];
    
    [self.view layoutIfNeeded];
    
    [UIView animateWithDuration:0.3
                     animations:^{
                         
                         self.secondTextField.alpha = 0;
                         
                     } completion:^(BOOL finished) {
                         
                         if (finished) {
                             self.topConstraint.constant = self.topConstraint.constant - kXYEnterCodeViewControllerTopConstraintConstantOfConfirmMode;
                             
                             [self.view removeConstraint:self.nextButtonYConstraint];
                             [self.view addConstraint:self.newNextButtonYConstraint];
                             
                             [self.view removeConstraint:self.bottomButtonYConstraint];
                             [self.view addConstraint:self.newBottomButtonYConstraint];
                             
                             [self.nextButton removeTarget:self
                                                    action:@selector(nextButtonPressedFromEnterCodeStage)
                                          forControlEvents:UIControlEventTouchUpInside];
                             [self.nextButton addTarget:self
                                                 action:@selector(yesButtonSelected)
                                       forControlEvents:UIControlEventTouchUpInside];
                             
                             [UIView animateWithDuration:0.3
                                              animations:^{
                                                  [self.view layoutIfNeeded];
                                                  
                                                  [self.nextButton changeToYesButton];
                                                  
                                                  self.noButton.alpha = 1;
                                                  self.orLabel.alpha = 1;
                                                  self.secondNoticeLabel.alpha = 1;
                                                  self.firstNoticeLabel.alpha = 1;
                                                  
                                              } completion:nil];
                         }
                     }];
}

- (void)rollBackToInitialEnterCodeStageFromConfrimationStage
{
    self.currentOrganization = nil;
    [UIView animateWithDuration:0.3
                     animations:^{
                         
                         self.noButton.alpha = 0;
                         self.orLabel.alpha = 0;
                         self.secondNoticeLabel.alpha = 0;
                         self.firstNoticeLabel.alpha = 0;
                         
                     } completion:^(BOOL finished) {
                         if (finished) {
                             
                             [self.view removeConstraints:@[self.noButtonXConstraint, self.noButtonYConstraint]];
                             [self.view removeConstraints:@[self.orLabelXConstraint, self.orLabelYConstraint]];
                             [self.view removeConstraints:@[self.secondNoticeLabelXConstraint, self.secondNoticeLabelYConstraint]];
                             [self.view removeConstraints:@[self.firstNoticeLabelXConstraint, self.firstNoticeLabelYConstraint]];
                             
                             [self.view removeConstraint:self.newNextButtonYConstraint];
                             [self.view addConstraint:self.nextButtonYConstraint];
                             
                             [self.view removeConstraint:self.newBottomButtonYConstraint];
                             [self.view addConstraint:self.bottomButtonYConstraint];
                             
                             self.topConstraint.constant = kXYEnterCodeViewControllerTopConstraintDefaultConstant;
                             
                             [self.nextButton removeTarget:self
                                                    action:@selector(yesButtonSelected)
                                          forControlEvents:UIControlEventTouchUpInside];
                             [self.nextButton addTarget:self
                                                 action:@selector(nextButtonPressedFromEnterCodeStage)
                                       forControlEvents:UIControlEventTouchUpInside];
                             [self.nextButton pausePulsating];
                             
                             [UIView animateWithDuration:0.3
                                              animations:^{
                                                  
                                                  [self.view layoutIfNeeded];
                                                  
                                                  self.secondTextField.alpha = 1;
                                                  
                                                  [self.nextButton changeToNextButton];
                                                  
                                              } completion:^(BOOL finished) {
                                                  
                                                  if (finished) {
                                                      
                                                      [self.noButton removeFromSuperview];
                                                      [self.orLabel removeFromSuperview];
                                                      [self.secondNoticeLabel removeFromSuperview];
                                                      [self.firstNoticeLabel removeFromSuperview];
                                                  }
                                                  
                                              }];
                         }
                     }];
}


#pragma mark - Confirm state properties setup

- (XYTextField *)firstTextField
{
    if (!_firstTextField) {
        XYTextField *firstTextField = [[XYTextField alloc] init];
        firstTextField.delegate = self;
        firstTextField.font = [UIFont fontWithName:@"OpenSans" size:15];
        firstTextField.translatesAutoresizingMaskIntoConstraints = NO;
        
        NSLayoutConstraint *width = [NSLayoutConstraint constraintWithItem:firstTextField
                                                                 attribute:NSLayoutAttributeWidth
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:1
                                                                  constant:200];
        NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:firstTextField
                                                                  attribute:NSLayoutAttributeHeight
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:nil
                                                                  attribute:NSLayoutAttributeNotAnAttribute
                                                                 multiplier:1
                                                                   constant:40];
        [firstTextField addConstraints:@[width, height]];
        
        _firstTextField = firstTextField;
    }
    return _firstTextField;
}

- (UILabel *)badCodeLabel
{
    if (!_badCodeLabel) {
        _badCodeLabel = [[UILabel alloc] init];
        _badCodeLabel.textColor = [UIColor colorWithRed:244.0f/255.0f green:228.0f/255.0f blue:223.0f/255.0f alpha:1.0f];
        _badCodeLabel.font = [UIFont fontWithName:@"OpenSans" size:15];
        [_badCodeLabel sizeToFit];
        _badCodeLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _badCodeLabel.hidden = YES;
    }
    return _badCodeLabel;
}

- (UIButton *)noButton
{
    if (!_noButton) {
        UIButton *noButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [noButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        NSString *noString = @"No";
        [noButton setTitle:noString forState:UIControlStateNormal];
        noButton.titleLabel.font = [UIFont fontWithName:@"OpenSans" size:13];
        noButton.backgroundColor = [UIColor clearColor];
        [noButton sizeToFit];
        noButton.translatesAutoresizingMaskIntoConstraints = NO;
        
        _noButton = noButton;
    }
    return _noButton;
}

- (UIButton *)forgotPasswordButton
{
    if (!_forgotPasswordButton) {
        UIButton *forgotPasswordButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [forgotPasswordButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        NSString *forgotPasswordString = @"Forgot your Password?";
        [forgotPasswordButton setTitle:forgotPasswordString forState:UIControlStateNormal];
        forgotPasswordButton.titleLabel.font = [UIFont fontWithName:@"OpenSans" size:13];
        forgotPasswordButton.backgroundColor = [UIColor clearColor];
        [forgotPasswordButton sizeToFit];
        forgotPasswordButton.translatesAutoresizingMaskIntoConstraints = NO;
        
        _forgotPasswordButton = forgotPasswordButton;
    }
    return _forgotPasswordButton;
}

- (UILabel *)orLabel
{
    if (!_orLabel) {
        UILabel *orLabel = [[UILabel alloc] init];
        NSString *orString = @"or";
        orLabel.text = orString;
        orLabel.font = [UIFont fontWithName:@"OpenSans" size:12];
        orLabel.textColor = [UIColor colorWithRed:82.0f/255.0f green:87.0f/255.0f blue:90.0f/255.0f alpha:1.0f];
        [orLabel sizeToFit];
        orLabel.translatesAutoresizingMaskIntoConstraints = NO;

        _orLabel = orLabel;
    }
    return _orLabel;
}

- (UILabel *)secondNoticeLabel
{
    if (!_secondNoticeLabel) {
        _secondNoticeLabel = [[UILabel alloc] init];
        _secondNoticeLabel.font = [UIFont fontWithName:@"OpenSans" size:15];
        _secondNoticeLabel.textColor = [UIColor whiteColor];
        _secondNoticeLabel.textAlignment = NSTextAlignmentCenter;
        _secondNoticeLabel.numberOfLines = 0;
        _secondNoticeLabel.preferredMaxLayoutWidth = 264;
        _secondNoticeLabel.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _secondNoticeLabel;
}

- (UILabel *)firstNoticeLabel
{
    if (!_firstNoticeLabel) {
        _firstNoticeLabel = [[UILabel alloc] init];
        _firstNoticeLabel.font = [UIFont fontWithName:@"OpenSans-Bold" size:30];
        _firstNoticeLabel.textColor = [UIColor whiteColor];
        _firstNoticeLabel.textAlignment = NSTextAlignmentCenter;
        _firstNoticeLabel.numberOfLines = 3;
        _firstNoticeLabel.preferredMaxLayoutWidth = 264;
        _firstNoticeLabel.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _firstNoticeLabel;
}

#pragma mark - Constraints

- (NSLayoutConstraint *)newSecondTextFieldYConstraint
{
    if (!_newSecondTextFieldYConstraint) {
        _newSecondTextFieldYConstraint = [NSLayoutConstraint constraintWithItem:self.secondTextField
                                                                      attribute:NSLayoutAttributeTop
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self.firstTextField
                                                                      attribute:NSLayoutAttributeBottom
                                                                     multiplier:1
                                                                       constant:[UIScreen mainScreen].bounds.size.height > 480.0f ? 24 : 12];
    }
    return _newSecondTextFieldYConstraint;
}

- (NSLayoutConstraint *)firstTextFieldXConstraint
{
    if (!_firstTextFieldXConstraint) {
        _firstTextFieldXConstraint = [NSLayoutConstraint constraintWithItem:self.firstTextField
                                                                  attribute:NSLayoutAttributeCenterX
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:self.view
                                                                  attribute:NSLayoutAttributeCenterX
                                                                 multiplier:1
                                                                   constant:0];
    }
    return _firstTextFieldXConstraint;
}

- (NSLayoutConstraint *)firstTextFieldYConstraint
{
    if (!_firstTextFieldYConstraint) {
        _firstTextFieldYConstraint = [NSLayoutConstraint constraintWithItem:self.firstTextField
                                                                  attribute:NSLayoutAttributeTop
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:self.xyloLogoImageView
                                                                  attribute:NSLayoutAttributeBottom
                                                                 multiplier:1
                                                                   constant:[UIScreen mainScreen].bounds.size.height > 480.0f ? 42 : 27];
    }
    return _firstTextFieldYConstraint;
}

- (NSLayoutConstraint *)forgotPasswordButtonXConstraint
{
    if (!_forgotPasswordButtonXConstraint) {
        _forgotPasswordButtonXConstraint = [NSLayoutConstraint constraintWithItem:self.forgotPasswordButton
                                                                        attribute:NSLayoutAttributeCenterX
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self.view
                                                                        attribute:NSLayoutAttributeCenterX
                                                                       multiplier:1
                                                                         constant:0];
    }
    return _forgotPasswordButtonXConstraint;
}

- (NSLayoutConstraint *)forgotPasswordButtonYConstraint
{
    if (!_forgotPasswordButtonYConstraint) {
        _forgotPasswordButtonYConstraint = [NSLayoutConstraint constraintWithItem:self.forgotPasswordButton
                                                                        attribute:NSLayoutAttributeTop
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self.nextButton
                                                                        attribute:NSLayoutAttributeBottom
                                                                       multiplier:1
                                                                         constant:[UIScreen mainScreen].bounds.size.height > 480.0f ? 29 : 15];
    }
    return _forgotPasswordButtonYConstraint;
}

- (NSLayoutConstraint *)badCodeLabelXConstraint
{
    if (!_badCodeLabelXConstraint) {
        _badCodeLabelXConstraint = [NSLayoutConstraint constraintWithItem:self.badCodeLabel
                                                                attribute:NSLayoutAttributeCenterX
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:self.view
                                                                attribute:NSLayoutAttributeCenterX
                                                               multiplier:1
                                                                 constant:-kXYEnterCodeViewControllerOffscreenOffset];
    }
    return _badCodeLabelXConstraint;
}

- (NSLayoutConstraint *)badCodeLabelYConstraint
{
    if (!_badCodeLabelYConstraint) {
        _badCodeLabelYConstraint = [NSLayoutConstraint constraintWithItem:self.badCodeLabel
                                                                attribute:NSLayoutAttributeCenterY
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:self.nextButton
                                                                attribute:NSLayoutAttributeCenterY
                                                               multiplier:1
                                                                 constant:0];
    }
    return _badCodeLabelYConstraint;
}

- (NSLayoutConstraint *)noButtonXConstraint
{
    if (!_noButtonXConstraint) {
        NSLayoutConstraint *noButtonXConstraint = [NSLayoutConstraint constraintWithItem:self.noButton
                                                                               attribute:NSLayoutAttributeCenterX
                                                                               relatedBy:NSLayoutRelationEqual
                                                                                  toItem:self.view
                                                                               attribute:NSLayoutAttributeCenterX
                                                                              multiplier:1
                                                                                constant:0];
        _noButtonXConstraint = noButtonXConstraint;
    }
    return _noButtonXConstraint;
}

- (NSLayoutConstraint *)noButtonYConstraint
{
    if (!_noButtonYConstraint) {
        NSLayoutConstraint *noButtonYConstraint = [NSLayoutConstraint constraintWithItem:self.noButton
                                                                               attribute:NSLayoutAttributeBottom
                                                                               relatedBy:NSLayoutRelationEqual
                                                                                  toItem:self.view
                                                                               attribute:NSLayoutAttributeBottom
                                                                              multiplier:1
                                                                                constant:[UIScreen mainScreen].bounds.size.height > 480.0f ? -60 : -40];
        _noButtonYConstraint = noButtonYConstraint;
    }
    return _noButtonYConstraint;
}

- (NSLayoutConstraint *)orLabelXConstraint
{
    if (!_orLabelXConstraint) {
        NSLayoutConstraint *orLabelXConstraint = [NSLayoutConstraint constraintWithItem:self.orLabel
                                                                              attribute:NSLayoutAttributeCenterX
                                                                              relatedBy:NSLayoutRelationEqual
                                                                                 toItem:self.view
                                                                              attribute:NSLayoutAttributeCenterX
                                                                             multiplier:1
                                                                               constant:0];
        _orLabelXConstraint = orLabelXConstraint;
    }
    return _orLabelXConstraint;
}

- (NSLayoutConstraint *)orLabelYConstraint
{
    if (!_orLabelYConstraint) {
        NSLayoutConstraint *orLabelYConstraint = [NSLayoutConstraint constraintWithItem:self.orLabel
                                                                              attribute:NSLayoutAttributeBottom
                                                                              relatedBy:NSLayoutRelationEqual
                                                                                 toItem:self.noButton
                                                                              attribute:NSLayoutAttributeTop
                                                                             multiplier:1
                                                                               constant:[UIScreen mainScreen].bounds.size.height > 480.0f ? -26 : - 16];
        _orLabelYConstraint = orLabelYConstraint;
    }
    return _orLabelYConstraint;
}

- (NSLayoutConstraint *)secondNoticeLabelXConstraint
{
    if (!_secondNoticeLabelXConstraint) {
        NSLayoutConstraint *secondNoticeLabelXConstraint = [NSLayoutConstraint constraintWithItem:self.secondNoticeLabel
                                                                                        attribute:NSLayoutAttributeCenterX
                                                                                        relatedBy:NSLayoutRelationEqual
                                                                                           toItem:self.view
                                                                                        attribute:NSLayoutAttributeCenterX
                                                                                       multiplier:1
                                                                                         constant:0];
        _secondNoticeLabelXConstraint = secondNoticeLabelXConstraint;
    }
    return _secondNoticeLabelXConstraint;
}

- (NSLayoutConstraint *)secondNoticeLabelYConstraint
{
    if (!_secondNoticeLabelYConstraint) {
        NSLayoutConstraint *secondNoticeLabelYConstraint = [NSLayoutConstraint constraintWithItem:self.secondNoticeLabel
                                                                                        attribute:NSLayoutAttributeBottom
                                                                                        relatedBy:NSLayoutRelationEqual
                                                                                           toItem:self.nextButton
                                                                                        attribute:NSLayoutAttributeTop
                                                                                       multiplier:1
                                                                                         constant:[UIScreen mainScreen].bounds.size.height > 480.0f ? -42 : -32];
        _secondNoticeLabelYConstraint = secondNoticeLabelYConstraint;
    }
    return _secondNoticeLabelYConstraint;
}

- (NSLayoutConstraint *)firstNoticeLabelXConstraint
{
    if (!_firstNoticeLabelXConstraint) {
        NSLayoutConstraint *firstNoticeLabelXConstraint = [NSLayoutConstraint constraintWithItem:self.firstNoticeLabel
                                                                                       attribute:NSLayoutAttributeCenterX
                                                                                       relatedBy:NSLayoutRelationEqual
                                                                                          toItem:self.view
                                                                                       attribute:NSLayoutAttributeCenterX
                                                                                      multiplier:1
                                                                                        constant:0];
        _firstNoticeLabelXConstraint = firstNoticeLabelXConstraint;
    }
    return _firstNoticeLabelXConstraint;
}

- (NSLayoutConstraint *)firstNoticeLabelYConstraint
{
    if (!_firstNoticeLabelYConstraint) {
        NSLayoutConstraint *firstNoticeLabelYConstraint = [NSLayoutConstraint constraintWithItem:self.firstNoticeLabel
                                                                                       attribute:NSLayoutAttributeBottom
                                                                                       relatedBy:NSLayoutRelationEqual
                                                                                          toItem:self.secondNoticeLabel
                                                                                       attribute:NSLayoutAttributeTop
                                                                                      multiplier:1
                                                                                        constant:-25];
        _firstNoticeLabelYConstraint = firstNoticeLabelYConstraint;
    }
    return _firstNoticeLabelYConstraint;
}

- (NSLayoutConstraint *)newNextButtonYConstraint
{
    if (!_newNextButtonYConstraint) {
        NSLayoutConstraint *newNextButtonYConstraint = [NSLayoutConstraint constraintWithItem:self.nextButton
                                                                                    attribute:NSLayoutAttributeBottom
                                                                                    relatedBy:NSLayoutRelationEqual
                                                                                       toItem:self.orLabel
                                                                                    attribute:NSLayoutAttributeTop
                                                                                   multiplier:1
                                                                                     constant:-26];
        _newNextButtonYConstraint = newNextButtonYConstraint;
    }
    return _newNextButtonYConstraint;
}

- (NSLayoutConstraint *)newBottomButtonYConstraint
{
    if (!_newBottomButtonYConstraint) {
        NSLayoutConstraint *newBottomButtonYConstraint = [NSLayoutConstraint constraintWithItem:self.bottomButton
                                                                                     attribute:NSLayoutAttributeTop
                                                                                     relatedBy:NSLayoutRelationEqual
                                                                                        toItem:self.view
                                                                                     attribute:NSLayoutAttributeBottom
                                                                                    multiplier:1
                                                                                      constant:0];
        _newBottomButtonYConstraint = newBottomButtonYConstraint;
    }
    return _newBottomButtonYConstraint;
}

#pragma mark - UITextFieldDelegate methods

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (self.badCodeEnteredState)
        [self toggleErrorStageWithMessage:nil];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.firstTextField) {
        [self.secondTextField becomeFirstResponder];
    } else if (textField == self.secondTextField) {
        [self.secondTextField resignFirstResponder];
    }
    
    if ([self.firstTextField hasText] && [self.secondTextField hasText])
        [self.nextButton startPulsating];
    
    return YES;
}

@end

//
//  XYLoginViewController.m
//  xylo
//
//  Created by Lukas Kekys on 27/06/14.
//  Copyright (c) 2014 Seriously. All rights reserved.
//

#import "XYLoginViewController.h"
#import "XYTextField.h"
#import "XYRegistrationNextButton.h"
#import "XYLoginService.h"
#import "XYPersonalInformationViewController.h"
#import "XYPasswordResetViewController.h"
#import "XYOrganizationService.h"

#define kXYLoginViewController_iPhone4LogoOffset 47
#define kXYLoginViewController_iPhone4EmailTextFieldOffset 25
#define kXYLoginViewController_iPhone4PasswordTextFieldOffset 10
#define kXYLoginViewController_iPhone4NextButtonOffset 142
#define kXYLoginViewController_iPhone4ForgotPasswordButtonOffset 22

#define kXYLoginViewController_nextButtonLeftOffset 124
#define kXYLoginViewController_errorLabelLeftOffset 20

@interface XYLoginViewController () <XYTextFieldDelegate>

//constraints
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *logoConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *emailTextfieldTopOffsetConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *passwordTopOffsetConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *nextButtonTopOffsetConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *forgotPasswordButtonTopOffsetConstraint;

//animated constraints
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *nextButtonLeftConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *errorLabelLeftConstraint;

//other outlets
@property (nonatomic, weak) IBOutlet XYTextField *emailTextField;
@property (nonatomic, weak) IBOutlet XYTextField *passwordTextField;
@property (nonatomic, weak) IBOutlet XYRegistrationNextButton *nextButton;
@property (nonatomic, weak) IBOutlet UIButton *forgotPasswordButton;
@property (nonatomic, weak) IBOutlet UIButton *registerButton;
@property (nonatomic, weak) IBOutlet UILabel *errorLabel;

- (IBAction)nextSelected:(XYRegistrationNextButton *)nextButton;
- (IBAction)forgotPasswordSelected:(UIButton *)sender;
- (IBAction)registerSelected:(UIButton *)sender;

@end

@implementation XYLoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [self setupView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - View setup and login functions

- (void)setupView
{
    NSString *forgotPasswordString = @"Forgot your Password?";
    [self.forgotPasswordButton setTitle:forgotPasswordString forState:UIControlStateNormal];
    self.forgotPasswordButton.titleLabel.font = [UIFont fontWithName:@"OpenSans" size:13];
    
    NSString *registerString = @"Register";
    [self.registerButton setTitle:registerString forState:UIControlStateNormal];
    
    NSString *emailString = @"E-mail";
    self.emailTextField.placeholder = emailString;
    self.emailTextField.xyTextFieldDelegate = self;
    
    NSString *passwordString = @"Password";
    self.passwordTextField.placeholder = passwordString;
    self.passwordTextField.xyTextFieldDelegate = self;
    
    self.registerButton.backgroundColor = [UIColor colorWithRed:29.0f/255.0f green:33.0f/255.0f blue:35.0f/255.0f alpha:1.0f];
    self.registerButton.titleLabel.font = [UIFont fontWithName:@"OpenSans" size:15];
    
    NSString *errorString = @"Sorry, bad email or password";
    self.errorLabel.text = errorString;
    
    
    UIGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                              action:@selector(closeKeyboard)];
    [self.view addGestureRecognizer:recognizer];
    
    if (SMALLER_SCREEN) {
        
        self.logoConstraint.constant = kXYLoginViewController_iPhone4LogoOffset;
        self.emailTextfieldTopOffsetConstraint.constant = kXYLoginViewController_iPhone4EmailTextFieldOffset;
        self.passwordTopOffsetConstraint.constant = kXYLoginViewController_iPhone4PasswordTextFieldOffset;
        self.nextButtonTopOffsetConstraint.constant = kXYLoginViewController_iPhone4NextButtonOffset;
        self.forgotPasswordButtonTopOffsetConstraint.constant = kXYLoginViewController_iPhone4ForgotPasswordButtonOffset;
    }
}

- (void)closeKeyboard
{
    if ([self.emailTextField isFirstResponder])
        [self.emailTextField resignFirstResponder];
    else if ([self.passwordTextField isFirstResponder])
        [self.passwordTextField resignFirstResponder];
    
    if ([self.emailTextField hasText] && [self.passwordTextField hasText])
        [self.nextButton startPulsating];
    else {
        [self.nextButton pausePulsating];
    }
    
    //toggle normal view
    [self toggleNormalMode];
}

- (void)toggleErrorStageWithMessage:(NSString *)message
{
    self.errorLabelLeftConstraint.constant = kXYLoginViewController_errorLabelLeftOffset;
    self.nextButtonLeftConstraint.constant = self.view.frame.size.width+20; // +20 just to add further to the left, so the button is not visible if drawn out of the frame
    
    [UIView animateWithDuration:0.2
                     animations:^{
                         
                         [self.view layoutIfNeeded];
                         self.view.backgroundColor = [UIColor colorWithRed:196.0f/255.0f green:90.0f/255.0f blue:32.0f/255.0f alpha:1.0f];
                         
                         self.forgotPasswordButton.alpha = 0;
                         
                     } completion:nil];
}

- (void)toggleNormalMode
{
    self.errorLabelLeftConstraint.constant = -self.view.frame.size.width;
    self.nextButtonLeftConstraint.constant = kXYLoginViewController_nextButtonLeftOffset;
    
    [UIView animateWithDuration:0.2
                     animations:^{
                         
                         [self.view layoutIfNeeded];
                         self.view.backgroundColor = [UIColor colorWithRed:49.0f/255.0f green:56.0f/255.0f blue:60.0f/255.0f alpha:1.0f];
                         
                         self.forgotPasswordButton.alpha = 1;
                         
                     } completion:nil];
}


#pragma mark - IBActions

- (IBAction)nextSelected:(XYRegistrationNextButton *)nextButton
{
    [self closeKeyboard];
    NSString *username = self.emailTextField.text;
    NSString *password = self.passwordTextField.text;
    
    if (username.length > 0 && password.length > 0) {
        
        [self.nextButton startLoadingIndicator];
        
        [XYLoginService loginUserWithEmail:username
                                  password:password
                              successBlock:^ {
                                  
                                  [self.nextButton pauseLoadingIndicator];
                                  [self.delegate loginViewControllerDidLogIn:self];
                                  
                                  [XYOrganizationService getMasterUserOrganizationsSuccessBlock:^ {
                                      
                                      [[NSNotificationCenter defaultCenter] postNotificationName:kOrganizationListUpdatedNotification object:nil];
                                      
                                  } failureBlock:^(XYOrganizationServiceCodeCheckError codeCheckError){
                                      
                                  }];
                                  
                              } failureBlock:^{
                                  [self.nextButton pauseLoadingIndicator];
                                  
                                  NSString *badLoginString = @"Sorry, bad email or password";
                                  [self toggleErrorStageWithMessage:badLoginString];
                              }];
    }
    else {
        
        NSString *message = (username.length == 0) ? @"Please enter your e-mail address" : @"Please enter your password";
        [self showAlertWithTitle:nil andErrorMessage:message];
    }
}

- (IBAction)forgotPasswordSelected:(UIButton *)sender
{
    XYPasswordResetViewController *passwordResetViewController = [[XYPasswordResetViewController alloc] init];
    [self.navigationController pushViewController:passwordResetViewController animated:YES];
}

- (IBAction)registerSelected:(UIButton *)sender
{
    XYPersonalInformationViewController *personalInfoController = [[XYPersonalInformationViewController alloc] initWithNibName:@"XYPersonalInformationViewController" bundle:nil];
    [self.navigationController pushViewController:personalInfoController animated:YES];
}

#pragma mark - XYTextfieldDelegate

- (void)textFieldBecameActive:(XYTextField *)textField
{
    [self toggleNormalMode];
}

#pragma mark - XYTextFieldView delegate

- (void)returnButtonSelectedInTextField:(XYTextField *)textField
{
    if (textField == self.emailTextField) {
        [self.passwordTextField becomeFirstResponder];
    } else if (textField == self.passwordTextField) {
        [self.passwordTextField resignFirstResponder];
    }
    
    if ([self.emailTextField hasText] && [self.passwordTextField hasText])
        [self.nextButton startPulsating];
    else {
        [self.nextButton pausePulsating];
    }
}


@end

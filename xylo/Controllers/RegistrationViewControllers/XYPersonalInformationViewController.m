//
//  XYPersonalInformationViewController.m
//  xylo
//
//  Created by Lukas Kekys on 03/03/14.
//  Copyright (c) 2014 Seriously. All rights reserved.
//

#import "XYPersonalInformationViewController.h"
#import "XYRegistrationNextButton.h"
#import "XYUtils.h"
#import "XYLoginService.h"
#import "XYOrganizationService.h"
#import "XYOrganization.h"
#import "XYUser.h"
#import "XYEnsembleSelectionViewController.h"
#import "XYEnsembleService.h"

@interface XYPersonalInformationViewController () <UIGestureRecognizerDelegate>

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *nextButtonBottomConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *nextButtonTopConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *nameTextFieldTopConstraint;

@property (nonatomic, weak) IBOutlet UILabel *personalInfoLabel;
@property (nonatomic, weak) IBOutlet UILabel *screenNumberLabel;
@property (nonatomic, weak) IBOutlet XYRegistrationNextButton *nextButton;

@property (nonatomic, weak) IBOutlet XYTextField *firstNameTextField;
@property (nonatomic, weak) IBOutlet XYTextField *lastNameTextField;
@property (nonatomic, weak) IBOutlet XYTextField *emailTextField;
@property (nonatomic, weak) IBOutlet XYTextField *passwordTextField;
@property (nonatomic, weak) IBOutlet XYTextField *repeatPasswordTextField;

@property (nonatomic, weak) IBOutlet UIView *containerView;

- (IBAction)nextButtonPressed:(id)sender;

@end

@implementation XYPersonalInformationViewController

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
    [self setupView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.scrollView addSubview:self.containerView];
    
    //to better position objects on smaller screens
    if (SMALLER_SCREEN) {
        self.nameTextFieldTopConstraint.constant = 25;
        self.nextButtonBottomConstraint.constant = 40;
        self.nextButtonTopConstraint.constant = 18;
    }
    
#warning remove or find out how this works correctly
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - View setup

- (void)setupView
{
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    self.trackKeyboard = YES;
    
    self.firstNameTextField.xyTextFieldDelegate = self;
    self.lastNameTextField.xyTextFieldDelegate = self;
    self.emailTextField.xyTextFieldDelegate = self;
    self.passwordTextField.xyTextFieldDelegate = self;
    self.repeatPasswordTextField.xyTextFieldDelegate = self;
    
    UIFont *textFieldFont = [UIFont fontWithName:@"OpenSans" size:15];
    self.firstNameTextField.font = textFieldFont;
    self.lastNameTextField.font = textFieldFont;
    self.emailTextField.font = textFieldFont;
    self.passwordTextField.font = textFieldFont;
    self.repeatPasswordTextField.font = textFieldFont;
    
    UIColor *placeholderColor = [UIColor colorWithRed:139.0f/255.0f
                                                green:160.0f/255.0f
                                                 blue:165.0f/255.0f
                                                alpha:1];
    
    NSString *firstNameString = @"First Name";
    NSString *lastNameString = @"Last Name";
    NSString *emailString = @"Email";
    NSString *passwordString = @"New Password";
    NSString *repeatPasswordString = @"Repeat Password";
    self.firstNameTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:firstNameString
                                                                                    attributes:@{NSForegroundColorAttributeName:placeholderColor}];
    self.lastNameTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:lastNameString
                                                                                   attributes:@{NSForegroundColorAttributeName:placeholderColor}];
    self.emailTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:emailString
                                                                                attributes:@{NSForegroundColorAttributeName:placeholderColor}];;
    self.passwordTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:passwordString
                                                                                   attributes:@{NSForegroundColorAttributeName:placeholderColor}];;
    self.repeatPasswordTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:repeatPasswordString
                                                                                         attributes:@{NSForegroundColorAttributeName:placeholderColor}];;
    
    NSString *personalInfoString = @"Personal Information";
    self.personalInfoLabel.font = [UIFont fontWithName:@"OpenSans-Bold" size:20];
    self.personalInfoLabel.text = personalInfoString;
    
    self.screenNumberLabel.font = [UIFont fontWithName:@"OpenSans-Light" size:20];
    self.screenNumberLabel.textColor = [UIColor colorWithRed:153.0f/255.0f green:155.0f/255.0f blue:157.0f/255.0f alpha:1.0];
    self.screenNumberLabel.text = @"1/2";
}

#pragma mark - XYTextFieldView delegate

- (void)returnButtonSelectedInTextField:(XYTextField *)textField
{
    if ([textField isEqual:self.firstNameTextField]) {
        [self.lastNameTextField becomeFirstResponder];
    }
    else if ([textField isEqual:self.lastNameTextField]) {
        [self.emailTextField becomeFirstResponder];
    }
    else if ([textField isEqual:self.emailTextField]) {
        [self.passwordTextField becomeFirstResponder];
    }
    else if ([textField isEqual:self.passwordTextField]) {
        [self.repeatPasswordTextField becomeFirstResponder];
    }
    else {
        [textField resignFirstResponder];
    }
}

#pragma mark - IBActions

- (IBAction)nextButtonPressed:(id)sender
{
//    [self.nextButton startLoadingIndicator];
//    [XYLoginService loginUserWithEmail:@"lukas@seriouslyinc.com" password:@"seriously" successBlock:^(XYUser *user) {
//        
//        NSManagedObjectContext *context = [NSManagedObjectContext MR_defaultContext];
//        XYOrganization *currentOrganization = [XYOrganization MR_findFirstByAttribute:@"organizationID" withValue:[self.organizationId stringValue] inContext:context];
//        [user addOrganizationsObject:currentOrganization];
//        [context MR_saveOnlySelfAndWait];
//        
//        [XYOrganizationService getEnsemblesForOrganizationWithStringId:[currentOrganization.organizationID stringValue] successBlock:^(NSSet *ensembleSet, XYLoginServiceCodeCheckError codeCheckError) {
//            
//            //function returns when positions are downloaded
//            [XYOrganizationService getPositionsForEnsembles:ensembleSet successBlock:^{
//                
//                [XYEnsembleService getInstrumentsForEnsembles:ensembleSet successBlock:^{
//                   
//                    [self showEnsembleSelectionViewForOrganization:currentOrganization];
//                    [self.nextButton changeToNextButton];
//                    
//                } failureBlock:^{
//                    //show error
//                }];
//            } failureBlock:^{
//                NSLog(@"something went wrong 'getPositionsForEnsembles' ");
//                [self.nextButton changeToNextButton];
//            }];
//            
//        } failureBlock:^{
//            NSLog(@"Failure getting ensembles");
//            [self.nextButton changeToNextButton];
//        }];
//    } failureBlock:^{
//         NSLog(@"Failure logging in");
//        [self.nextButton changeToNextButton];
//    }];
    
    
    if ([self mandatoryFieldsValid]) {
    
        NSString *email = self.emailTextField.text;
        NSString *password = self.passwordTextField.text;
        
        [self.nextButton startLoadingIndicator];
        [XYLoginService registerUserWithName:self.firstNameTextField.text
                                    lastName:self.lastNameTextField.text
                                       email:email
                                    password:self.passwordTextField.text
                         andRepeatedPassword:self.repeatPasswordTextField.text
                                successBlock:^{
                                    
                                    [XYLoginService loginUserWithEmail:email password:password successBlock:^ {
                                        
                                    } failureBlock:^{
                                        NSLog(@"Failure logging in");
                                        [self.nextButton changeToNextButton];
                                        [self showAlertWithTitle:nil andErrorMessage:@"Something went wrong, try again later."];
                                    }];
                                    
                                } failureBlock:^(NSString *errorMessage) {
                                    NSLog(@"Registration failed");
                                    [self.nextButton changeToNextButton];
                                    [self showAlertWithTitle:nil andErrorMessage:errorMessage];
                                }];
    }
}


#pragma mark - Helpers

- (BOOL)mandatoryFieldsValid
{
    BOOL result = YES;
    UIAlertView *alertView = nil;
    
    if (![XYUtils emailFormatValid:self.emailTextField.text]) {
        alertView = [[UIAlertView alloc] initWithTitle:nil
                                               message:@"Please enter a valid email address"
                                              delegate:nil
                                     cancelButtonTitle:@"OK"
                                     otherButtonTitles:nil];
        result = NO;
    }
    else if (![self.passwordTextField.text isEqualToString:self.repeatPasswordTextField.text]) {
        alertView = [[UIAlertView alloc] initWithTitle:nil
                                               message:@"The passwords do not match"
                                              delegate:nil
                                     cancelButtonTitle:@"OK"
                                     otherButtonTitles:nil];
        result = NO;
    }
    
    if (alertView)
        [alertView show];
    
    return result;
}

- (void)showEnsembleSelectionViewForOrganization:(XYOrganization *)organization
{
    XYEnsembleSelectionViewController *ensembleSelectionViewController = [[XYEnsembleSelectionViewController alloc] initWithNibName:@"XYEnsembleSelectionViewController" bundle:nil];
    ensembleSelectionViewController.currentOrganization = organization;
    [self.navigationController pushViewController:ensembleSelectionViewController animated:YES];
}

@end

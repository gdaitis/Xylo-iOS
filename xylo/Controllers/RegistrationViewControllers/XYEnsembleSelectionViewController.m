//
//  XYEnsembleSelectionViewControllerTESTViewController.m
//  xylo
//
//  Created by Lukas Kekys on 20/03/14.
//  Copyright (c) 2014 Seriously. All rights reserved.
//

#import "XYEnsembleSelectionViewController.h"
#import "XYEnsembleSelectionButton.h"
#import "XYOrganization.h"
#import "XYEnsemble.h"
#import "XYUser+UserFunctions.h"
#import "XYEnsembleSelectionScrollView.h"

#import "XYOrganizationService.h"
#import "XYRootViewController.h"
#import "XYRegistrationNextButton.h"
#import "XYPosition.h"
#import "XYPositionButton.h"
#import "XYInstrumentType.h"
#import "XYInstrumentTypeButton.h"

#import "UIView+NibLoading.h"



#define kXYEnsembleSelectionViewController_AnimationDuration 0.3

#define kXYEnsembleSelectionViewController_ButtonsOffsetFromTop 80
#define kXYEnsembleSelectionViewController_ButtonsOffsetFromBottom 10
#define kXYEnsembleSelectionViewController_ButtonSizeHeight 56
#define kXYEnsembleSelectionViewController_ButtonSizeWidth  264
#define kXYEnsembleSelectionViewController_ButtonSpacingOffset 3
#define kXYEnsembleSelectionViewController_NextButtonOffset 10
#define kXYEnsembleSelectionViewController_NextButtonBottomOffset 30
#define kXYEnsembleSelectionViewController_NextButtonHeight 72

@interface XYEnsembleSelectionViewController ()

@property (nonatomic, weak) IBOutlet UILabel *yourEnsembleLabel;
@property (nonatomic, weak) IBOutlet UILabel *screenNumberLabel;

@property (nonatomic, weak) XYRegistrationNextButton *nextButton;
@property (nonatomic, weak) XYEnsembleSelectionButton *selectedEnsembleButton;
@property (nonatomic, weak) XYPositionButton *selectedPositionButton;
@property (nonatomic, assign) CGPoint buttonContentOffset;

@property (nonatomic, strong) NSMutableArray *ensembleButtons;

@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation XYEnsembleSelectionViewController

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
    
    NSString *yourEnsemblesString = @"Your Ensembles";
    self.yourEnsembleLabel.text = yourEnsemblesString;
    self.screenNumberLabel.font = self.yourEnsembleLabel.font = [UIFont fontWithName:@"OpenSans" size:20.0];
    
    self.screenNumberLabel.text = @"2/2";
    
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    self.dataArray = [self.currentOrganization.ensembles sortedArrayUsingDescriptors:@[descriptor]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    
    [self fillViewWithEnsembleButtonsAnimated:NO withParentButton:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, self.nextButton.topConstraint.constant + kXYEnsembleSelectionViewController_NextButtonHeight + kXYEnsembleSelectionViewController_NextButtonBottomOffset);
}


- (void)fillViewWithEnsembleButtonsAnimated:(BOOL)animated withParentButton:(XYEnsembleSelectionButton *)parentButton
{
    NSInteger buttonCount = [self.dataArray count];
    int offset = 0;
    
    for (int i = 0; i < buttonCount; i++) {
        
        offset = (kXYEnsembleSelectionViewController_ButtonsOffsetFromTop + ((kXYEnsembleSelectionViewController_ButtonSpacingOffset + kXYEnsembleSelectionViewController_ButtonSizeHeight)*i));
        
        if (!(parentButton && offset == parentButton.topConstraint.constant)) {
            
            XYEnsembleSelectionButton *button = [[XYEnsembleSelectionButton alloc] init];
            button.ensemble = [self.dataArray objectAtIndex:i];
            [button setTranslatesAutoresizingMaskIntoConstraints:NO];
            
            [self setupEnsembleButtonTitle:button];
            [button addTarget:self action:@selector(ensembleButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            
            [self.scrollView addSubview:button];
            
            // Pin Width & Height
            [button addConstraint:[NSLayoutConstraint constraintWithItem:button
                                                               attribute:NSLayoutAttributeWidth
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:nil
                                                               attribute:NSLayoutAttributeNotAnAttribute
                                                              multiplier:1.0f
                                                                constant:kXYEnsembleSelectionViewController_ButtonSizeWidth]];
            
            [button addConstraint:[NSLayoutConstraint constraintWithItem:button
                                                               attribute:NSLayoutAttributeHeight
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:nil
                                                               attribute:NSLayoutAttributeNotAnAttribute
                                                              multiplier:1.0f
                                                                constant:kXYEnsembleSelectionViewController_ButtonSizeHeight]];
            
            
            //button top constraint
            button.topConstraint = [NSLayoutConstraint constraintWithItem:button
                                                                attribute:NSLayoutAttributeTop
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:self.scrollView
                                                                attribute:NSLayoutAttributeBottom
                                                               multiplier:1.0f
                                                                 constant:offset];
            [self.scrollView addConstraint:button.topConstraint];
            button.originalTopContstraintConstant = offset;
            
            //button center in view
            [self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:button
                                                                        attribute:NSLayoutAttributeCenterX
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self.scrollView
                                                                        attribute:NSLayoutAttributeCenterX
                                                                       multiplier:1.0f constant:0.0f]];
            
            if (animated)
                button.alpha = 0.0f;
        }
    }
    
    int nextButtonOffset = 0;
    
    //if next button is in the middle of the screen, we position it at the bottom.
    if ((offset + kXYEnsembleSelectionViewController_ButtonSizeHeight + kXYEnsembleSelectionViewController_NextButtonOffset) < self.view.frame.size.height - kXYEnsembleSelectionViewController_NextButtonBottomOffset - kXYEnsembleSelectionViewController_NextButtonHeight) {
        
        nextButtonOffset = self.view.frame.size.height - kXYEnsembleSelectionViewController_NextButtonBottomOffset - kXYEnsembleSelectionViewController_NextButtonHeight;
    }
    else {
        nextButtonOffset = offset + kXYEnsembleSelectionViewController_ButtonSizeHeight + kXYEnsembleSelectionViewController_NextButtonOffset;
    }
    
    if (!self.nextButton) {
        XYRegistrationNextButton *registrationButton = [[XYRegistrationNextButton alloc] init];
        self.nextButton = registrationButton;
        [self.nextButton setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.scrollView addSubview:self.nextButton];
        [self.nextButton addTarget:self action:@selector(nextButtonSelected) forControlEvents:UIControlEventTouchUpInside];
        
        [self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:self.nextButton
                                                                    attribute:NSLayoutAttributeCenterX
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:self.scrollView
                                                                    attribute:NSLayoutAttributeCenterX
                                                                   multiplier:1.0f constant:0.0f]];
        
        self.nextButton.topConstraint = [NSLayoutConstraint constraintWithItem:self.nextButton
                                                                     attribute:NSLayoutAttributeTop
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.scrollView
                                                                     attribute:NSLayoutAttributeBottom
                                                                    multiplier:1.0f
                                                                      constant:nextButtonOffset];
        [self.scrollView addConstraint:self.nextButton.topConstraint];
        
        [self.nextButton addConstraint:[NSLayoutConstraint constraintWithItem:self.nextButton
                                                                    attribute:NSLayoutAttributeWidth
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:nil
                                                                    attribute:NSLayoutAttributeNotAnAttribute
                                                                   multiplier:1.0f
                                                                     constant:72]];
        
        [self.nextButton addConstraint:[NSLayoutConstraint constraintWithItem:self.nextButton
                                                                    attribute:NSLayoutAttributeHeight
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:nil
                                                                    attribute:NSLayoutAttributeNotAnAttribute
                                                                   multiplier:1.0f
                                                                     constant:72]];
    }
    
    
    if (parentButton && animated) {
        [self.scrollView layoutIfNeeded];
        [self makeButtonsVisible];
        [self.nextButton changeToNextButton];
        
        
        [self adjustNextButtonOffset:nextButtonOffset withTarget:@selector(nextButtonSelected)];
    }
    
    [self.scrollView setNeedsUpdateConstraints];
    [self.scrollView layoutIfNeeded];
}

- (void)makeButtonsVisible
{
    NSArray *subviews = self.scrollView.subviews;
    NSInteger subviewCount = [subviews count];
    
    for (int i = 0; i < subviewCount; i++) {
        id view = [subviews objectAtIndex:i];
        if ([[view class] isSubclassOfClass:[XYEnsembleSelectionButton class]] || [[view class] isSubclassOfClass:[XYInstrumentTypeButton class]]) {
            
            [UIView animateWithDuration:kXYEnsembleSelectionViewController_AnimationDuration delay:0.0f options:UIViewAnimationOptionCurveLinear animations:^{
                ((XYEnsembleSelectionButton *)view).alpha = 1.0f;
                [self.scrollView layoutIfNeeded];
            } completion:^(__unused BOOL finished) {
            }];
        }
    }
}

- (void)ensembleButtonPressed:(XYEnsembleSelectionButton *)sender
{
    if (sender.selected) {
        self.selectedEnsembleButton = nil;
        [sender viewContracted];
        [self hidePositionButtonListForEnsembeButton:sender];
    }
    else {
        self.selectedEnsembleButton = sender;
        NSArray *subviews = self.scrollView.subviews;
        
        for (id view in subviews) {
            if ([[view class] isSubclassOfClass:[XYEnsembleSelectionButton class]] && ![view isEqual:sender]) {
                
                [UIView animateWithDuration:kXYEnsembleSelectionViewController_AnimationDuration delay:0.0f options:UIViewAnimationOptionCurveLinear animations:^{
                    ((XYEnsembleSelectionButton *)view).alpha = 0.0f;
                    [self.scrollView layoutIfNeeded];
                } completion:^(__unused BOOL finished) {
                        [view removeFromSuperview];
                }];
            }
        }
        
        [self performSelector:@selector(moveEnsembleButtonUp:) withObject:sender afterDelay:kXYEnsembleSelectionViewController_AnimationDuration];
    }
    sender.selected = !sender.selected;
}

- (void)moveEnsembleButtonUp:(XYEnsembleSelectionButton *)button
{
    button.topConstraint.constant = kXYEnsembleSelectionViewController_ButtonsOffsetFromTop;
    
    [UIView animateWithDuration:kXYEnsembleSelectionViewController_AnimationDuration delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.buttonContentOffset = self.scrollView.contentOffset;
        self.scrollView.contentOffset = CGPointZero;
        [self.scrollView layoutIfNeeded];
    } completion:^(__unused BOOL finished) {
        
        [button viewExpanded];
        [self showUserPositionListForButton:button];
    }];
}

- (void)showUserPositionListForButton:(XYEnsembleSelectionButton *)button
{
    [self loadAndShowPositionButtonsForEnsembleButton:button withSuccessBlock:^(int lastButtonPossition) {
        
        [self.nextButton changeToSelectButton];
        [self adjustNextButtonOffset:lastButtonPossition withTarget:@selector(selectButtonPressed)];
        [self updateEnsembleButtonTitle:button];
    }];
}

- (void)showUserInstrumentListForButton:(XYPositionButton *)button
{
    [self loadAndShowInstrumentButtonsForPositionButton:button withSuccessBlock:^(int lastButtonPossition) {
        
        [self.nextButton changeToSelectButton];
        [self adjustNextButtonOffset:lastButtonPossition withTarget:@selector(selectButtonPressed)];
        [self updatePositionButtonTitle:button];
    }];
}

- (void)hideInstrumentSelectionButtons:(XYPositionButton *)button
{
    //    [self hidePositionButtonListForEnsembeButton:button];
}

- (void)moveButtonToOriginalPosition:(XYEnsembleSelectionButton *)button
{
    button.topConstraint.constant = button.originalTopContstraintConstant;
    
    [UIView animateWithDuration:kXYEnsembleSelectionViewController_AnimationDuration delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self.scrollView layoutIfNeeded];
        self.scrollView.contentOffset = self.buttonContentOffset;
        
    } completion:^(__unused BOOL finished) {
        [self fillViewWithEnsembleButtonsAnimated:YES withParentButton:button];
    }];
}

- (void)movePositionButtonToOriginalPosition:(XYPositionButton *)button
{
    button.topConstraint.constant = button.originalTopContstraintConstant;
    
    [UIView animateWithDuration:kXYEnsembleSelectionViewController_AnimationDuration delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self.scrollView layoutIfNeeded];
        self.scrollView.contentOffset = self.buttonContentOffset;
        
    } completion:^(__unused BOOL finished) {
        
//        readd ensemble button, readd position buttons
        [self readdEnsembleAndPositionButtons];
        
    }];
}

- (void)readdEnsembleAndPositionButtons
{
    NSLog(@"self.selectedEnsembleButton = %@",self.selectedEnsembleButton);
//    [self.scrollView addSubview:self.selectedEnsembleButton];
    self.selectedEnsembleButton.alpha = 1.0f;
    [self loadAndShowPositionButtonsForEnsembleButton:self.selectedEnsembleButton withSuccessBlock:^(int lastButtonPossition) {
        [self adjustNextButtonOffset:lastButtonPossition withTarget:@selector(selectButtonPressed)];
    }];
    
}


#pragma mark - Position list loading

- (void)loadAndShowPositionButtonsForEnsembleButton:(XYEnsembleSelectionButton *)ensembleSelectionButton withSuccessBlock:(void (^)(int lastButtonPossition))successBlock
{
    NSArray *sortedPositions = [ensembleSelectionButton.ensemble.positions sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]]];
    int parentButtonOffset = ensembleSelectionButton.topConstraint.constant;
    
    NSMutableArray *positionButtonArray = [[NSMutableArray alloc] init];
    
    for (XYPosition *position in sortedPositions) {
        
        XYPositionButton *positionButton = [[XYPositionButton alloc] init];
        positionButton.translatesAutoresizingMaskIntoConstraints = NO;
        positionButton.position = position;
        positionButton.layer.cornerRadius = 4.0f;
        positionButton.layer.masksToBounds = YES;
        positionButton.parentEnsemble = ensembleSelectionButton.ensemble;
        [positionButton addTarget:self action:@selector(positionButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollView addSubview:positionButton];
        [positionButtonArray addObject:positionButton];
        
//        [self setupPositionButtonTitle:position];
        
        //if user selected this position mark him
        XYUser *masterUser = [XYUser masterUser];
        if ([positionButton.position.users containsObject:masterUser] && [masterUser.ensembles containsObject:ensembleSelectionButton.ensemble]) {
            
            NSMutableSet *positionUserSet = [NSMutableSet setWithSet:positionButton.position.users];
            for (XYUser *user in positionUserSet) {
                if ([user isEqual:masterUser]) {
                    positionButton.checked = YES;
                }
            }
        }
        
        //adding top constraint for button, latter these constraint will be changed to animate buttons down
        positionButton.topConstraint = [NSLayoutConstraint constraintWithItem:positionButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeTop multiplier:1.0 constant:parentButtonOffset];
        [self.scrollView addConstraint:positionButton.topConstraint];
        
        
        // Pin Width & Height
        [positionButton addConstraint:[NSLayoutConstraint constraintWithItem:positionButton
                                                                   attribute:NSLayoutAttributeWidth
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:nil
                                                                   attribute:NSLayoutAttributeNotAnAttribute
                                                                  multiplier:1.0f
                                                                    constant:kXYPositionButton_ButtonWidth]];
        
        [positionButton addConstraint:[NSLayoutConstraint constraintWithItem:positionButton
                                                                   attribute:NSLayoutAttributeHeight
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:nil
                                                                   attribute:NSLayoutAttributeNotAnAttribute
                                                                  multiplier:1.0f
                                                                    constant:kXYPositionButton_ButtonHeight]];
        [self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:positionButton
                                                                    attribute:NSLayoutAttributeCenterX
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:self.scrollView
                                                                    attribute:NSLayoutAttributeCenterX
                                                                   multiplier:1.0f constant:0.0f]];
    }
    [self.scrollView updateConstraints];
    [self.scrollView layoutIfNeeded];
    
    [self.scrollView bringSubviewToFront:ensembleSelectionButton];
    
    int buttonOffset = 0;
    //move buttons to places
    for (int i = 0; i < [positionButtonArray count]; i++) {
        
        XYPositionButton *positionButton = [positionButtonArray objectAtIndex:i];
        buttonOffset = parentButtonOffset + (kXYPositionButton_ButtonHeight * i) + (kXYEnsembleSelectionViewController_ButtonSpacingOffset * i);
        positionButton.topConstraint.constant = buttonOffset;
        positionButton.originalTopContstraintConstant = buttonOffset;
    }
    
    //animate changed constraints
    [self.scrollView setNeedsUpdateConstraints];
    
    [UIView animateWithDuration:0.25f animations:^{
        [self.scrollView layoutIfNeeded];
    } completion:^(BOOL finished) {
        
    }];
    
    if (successBlock)
        successBlock(buttonOffset + kXYPositionButton_ButtonHeight + kXYEnsembleSelectionViewController_ButtonsOffsetFromBottom);
}

- (void)hidePositionButtonListForEnsembeButton:(XYEnsembleSelectionButton *)ensembleSelectionButton
{
    NSArray *subviews = self.scrollView.subviews;
    
    for (id view in subviews) {
        
        if ([view isKindOfClass:[XYPositionButton class]]) {
            
            [UIView animateWithDuration:0.25f animations:^{
                ((XYPositionButton *)view).topConstraint.constant = ensembleSelectionButton.topConstraint.constant;
                [self.scrollView layoutIfNeeded];
            } completion:^(BOOL finished) {
                [view removeFromSuperview];
            }];
        }
    }
    
    [self setupEnsembleButtonTitle:ensembleSelectionButton];
    
    [self performSelector:@selector(moveButtonToOriginalPosition:) withObject:ensembleSelectionButton afterDelay:0.35f];
}

- (void)positionButtonPressed:(XYPositionButton *)positionButton
{
    if (positionButton.selected) {
        [positionButton viewContracted];
        [self hideInstrumentButtonListForPossitionButton:positionButton];
        self.selectedPositionButton = nil;
        positionButton.selected = !positionButton.selected;
    }
    else {
        self.selectedPositionButton = positionButton;
        if ([positionButton.position.positionID isEqualToNumber:[NSNumber numberWithInt:2]]) {
            [self hidePositionButtonsAndLeaveSelected:positionButton];
            self.selectedPositionButton = positionButton;
            positionButton.selected = !positionButton.selected;
        }
        else {
            self.selectedPositionButton = nil;
            XYUser *masterUser = [XYUser masterUser];
            if ([positionButton.position.users containsObject:masterUser] && [masterUser.ensembles containsObject:positionButton.parentEnsemble]) {
                
                NSMutableSet *positionUserSet = [NSMutableSet setWithSet:[positionButton.position.users mutableCopy]];
                for (XYUser *user in positionUserSet) {
                    if ([user isEqual:masterUser]) {
                        [positionUserSet removeObject:user];
                    }
                }
                positionButton.position.users = positionUserSet;
                positionButton.checked = NO;
                
                
                //if all ensembles are unselected, we must remove this ensemble from users ensembles
                NSManagedObjectContext *context = [NSManagedObjectContext MR_defaultContext];
                NSPredicate *userPredicate = [NSPredicate predicateWithFormat:@"ANY users == %@",masterUser];
                NSPredicate *ensemblePredicate = [NSPredicate predicateWithFormat:@"ensemble == %@",positionButton.parentEnsemble];
                NSPredicate *compoundPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[userPredicate,ensemblePredicate]];
                NSArray *positionArray = [XYPosition MR_findAllWithPredicate:compoundPredicate inContext:context];
                if ([positionArray count] == 0) {
                    
                    //remove ensemble from users ensembles
                    NSMutableSet *ensembleSet = [NSMutableSet setWithSet:[masterUser.ensembles mutableCopy]];
                    for (XYEnsemble *ensemble in ensembleSet) {
                        if ([ensemble isEqual:positionButton.parentEnsemble]) {
                            [ensembleSet removeObject:ensemble];
                            break;
                        }
                    }
                    masterUser.ensembles = ensembleSet;
                }
            }
            else {
                [positionButton.position addUsersObject:masterUser];
                [masterUser addEnsemblesObject:positionButton.parentEnsemble];
                
                positionButton.checked = YES;
            }
            
            NSManagedObjectContext *context = [NSManagedObjectContext MR_defaultContext];
            [context MR_saveOnlySelfAndWait];
            
            [self updateEnsembleButtonTitle:self.selectedEnsembleButton];
        }
    }
}


- (void)nextButtonSelected
{
    XYRootViewController *rootViewController = [[XYRootViewController alloc] init];
    [self.navigationController pushViewController:rootViewController animated:YES];
}

- (void)selectButtonPressed
{
    //hide instrument or position list
    [self.selectedEnsembleButton viewContracted];
    [self hidePositionButtonListForEnsembeButton:self.selectedEnsembleButton];
    
    self.selectedEnsembleButton = nil;
}

#pragma mark - Instrument list

//- (void)hidePossitionButtonsLeaveSelected:(XYPositionButton *)possitionButton
//{
//    if (possitionButton.selected) {
//        self.selectedPositionButton = nil;
//        [possitionButton viewContracted];
//        [self hideInstrumentSelectionButtons:possitionButton];
//    }
//    else {
//        self.selectedPositionButton = possitionButton;
//        NSArray *subviews = self.scrollView.subviews;
//        
//        for (id view in subviews) {
//            if (([[view class] isSubclassOfClass:[XYPositionButton class]] || [[view class] isSubclassOfClass:[XYEnsembleSelectionButton class]]) && ![view isEqual:possitionButton]) {
//                
//                [UIView animateWithDuration:kXYEnsembleSelectionViewController_AnimationDuration delay:0.0f options:UIViewAnimationOptionCurveLinear animations:^{
//                    ((XYPositionButton *)view).alpha = 0.0f;
//                    [self.scrollView layoutIfNeeded];
//                } completion:^(__unused BOOL finished) {
//                    [view removeFromSuperview];
//                }];
//            }
//        }
//        
//        [self performSelector:@selector(movePossitionButtonUp:) withObject:possitionButton afterDelay:kXYEnsembleSelectionViewController_AnimationDuration];
//    }
//    possitionButton.selected = !possitionButton.selected;
//}

- (void)hidePositionButtonsAndLeaveSelected:(XYPositionButton *)possitionButton
{
    NSArray *subviews = self.scrollView.subviews;
    
    for (UIView *view in subviews) {
        if (([view isKindOfClass:[XYEnsembleSelectionButton class]] || [view isKindOfClass:[XYPositionButton class]]) && ![view isEqual:possitionButton]) {
            
            [UIView animateWithDuration:kXYEnsembleSelectionViewController_AnimationDuration delay:0.0f options:UIViewAnimationOptionCurveLinear animations:^{
                view.alpha = 0.0f;
                [self.scrollView layoutIfNeeded];
            } completion:^(__unused BOOL finished) {
                
                if (![view isKindOfClass:[XYEnsembleSelectionButton class]]) {
                    [view removeFromSuperview];
                }
            }];
        }
    }
    
    [self performSelector:@selector(movePossitionButtonUp:) withObject:possitionButton afterDelay:0.35f];
}

- (void)hideInstrumentButtonListForPossitionButton:(XYPositionButton *)positionButton
{
    NSArray *subviews = self.scrollView.subviews;
    
    for (id view in subviews) {
        
        if ([view isKindOfClass:[XYInstrumentTypeButton class]]) {
            
            [UIView animateWithDuration:0.25f animations:^{
                ((XYInstrumentTypeButton *)view).topConstraint.constant = positionButton.topConstraint.constant;
                [self.scrollView layoutIfNeeded];
            } completion:^(BOOL finished) {
                [view removeFromSuperview];
            }];
        }
    }
    
#warning unfinished
    //    [self setupInstrumentButtonTitle:ensembleSelectionButton];
    [self performSelector:@selector(movePositionButtonToOriginalPosition:) withObject:positionButton afterDelay:0.35f];
}

- (void)movePossitionButtonUp:(XYPositionButton *)possitionButton
{
    possitionButton.topConstraint.constant = kXYEnsembleSelectionViewController_ButtonsOffsetFromTop;
    
    [UIView animateWithDuration:kXYEnsembleSelectionViewController_AnimationDuration delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.buttonContentOffset = self.scrollView.contentOffset;
        self.scrollView.contentOffset = CGPointZero;
        [self.scrollView layoutIfNeeded];
    } completion:^(__unused BOOL finished) {
        
        [possitionButton viewExpanded];
        [self showUserInstrumentListForButton:possitionButton];
    }];
}

- (void)loadAndShowInstrumentButtonsForPositionButton:(XYPositionButton *)parentButton withSuccessBlock:(void (^)(int lastButtonPossition))successBlock
{
    NSArray *sortedInstruments = [parentButton.parentEnsemble.instrumentTypes sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]]];
    int parentButtonOffset = parentButton.topConstraint.constant;
    
    NSMutableArray *instrumentButtonArray = [[NSMutableArray alloc] init];
    
    for (XYInstrumentType *instrument in sortedInstruments) {
        
        XYInstrumentTypeButton *button = [[XYInstrumentTypeButton alloc] init];
        button.ensemble = parentButton.parentEnsemble;
        button.parentPosition = parentButton.position;
        button.instrumentType = instrument;
        
        [button setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        [self setupPositionButtonTitle:parentButton];
        [button addTarget:self action:@selector(instrumentButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.scrollView addSubview:button];
        [instrumentButtonArray addObject:button];
        
        //if user selected this instrument mark it
//        XYUser *masterUser = [XYUser masterUser];
//        if ([parentButton.position.users containsObject:masterUser] && [masterUser.ensembles containsObject:ensembleSelectionButton.ensemble]) {
//            
//            NSMutableSet *positionUserSet = [NSMutableSet setWithSet:positionButton.position.users];
//            for (XYUser *user in positionUserSet) {
//                if ([user isEqual:masterUser]) {
//                    positionButton.checked = YES;
//                }
//            }
//        }
        
        //adding top constraint for button, latter these constraint will be changed to animate buttons down
        button.topConstraint = [NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeTop multiplier:1.0 constant:parentButtonOffset];
        [self.scrollView addConstraint:button.topConstraint];
        
        
        // Pin Width & Height
        [button addConstraint:[NSLayoutConstraint constraintWithItem:button
                                                                   attribute:NSLayoutAttributeWidth
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:nil
                                                                   attribute:NSLayoutAttributeNotAnAttribute
                                                                  multiplier:1.0f
                                                                    constant:kXYPositionButton_ButtonWidth]];
        
        [button addConstraint:[NSLayoutConstraint constraintWithItem:button
                                                                   attribute:NSLayoutAttributeHeight
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:nil
                                                                   attribute:NSLayoutAttributeNotAnAttribute
                                                                  multiplier:1.0f
                                                                    constant:kXYPositionButton_ButtonHeight]];
        [self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:button
                                                                    attribute:NSLayoutAttributeCenterX
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:self.scrollView
                                                                    attribute:NSLayoutAttributeCenterX
                                                                   multiplier:1.0f constant:0.0f]];
    }
    [self.scrollView updateConstraints];
    [self.scrollView layoutIfNeeded];
    
    [self.scrollView bringSubviewToFront:parentButton];
    
    int buttonOffset = 0;
    //move buttons to places
    for (int i = 0; i < [instrumentButtonArray count]; i++) {
        
        XYInstrumentTypeButton *instrumentButton = [instrumentButtonArray objectAtIndex:i];
        buttonOffset = parentButtonOffset + (kXYPositionButton_ButtonHeight * i) + (kXYEnsembleSelectionViewController_ButtonSpacingOffset * i);
        instrumentButton.topConstraint.constant = buttonOffset;
    }
    
    //animate changed constraints
    [self.scrollView setNeedsUpdateConstraints];
    
    [UIView animateWithDuration:0.25f animations:^{
        [self.scrollView layoutIfNeeded];
    } completion:^(BOOL finished) {
        
    }];
    
    if (successBlock)
        successBlock(buttonOffset + kXYPositionButton_ButtonHeight + kXYEnsembleSelectionViewController_ButtonsOffsetFromBottom);
}

- (void)instrumentButtonPressed:(XYInstrumentTypeButton *)instrumentButton
{
    XYUser *masterUser = [XYUser masterUser];
    if ([instrumentButton.instrumentType.users containsObject:masterUser] && [masterUser.userPlayedInstrumentTypes containsObject:instrumentButton.instrumentType]) {
        
        NSMutableSet *instrumentUserSet = [NSMutableSet setWithSet:[instrumentButton.instrumentType.users mutableCopy]];
        for (XYUser *user in instrumentUserSet) {
            if ([user isEqual:masterUser]) {
                [instrumentUserSet removeObject:user];
            }
        }
        instrumentButton.instrumentType.users = instrumentUserSet;
        instrumentButton.checked = NO;
        
        
        //if all instruments are unselected, we must remove this position from users positions
        NSManagedObjectContext *context = [NSManagedObjectContext MR_defaultContext];
        NSPredicate *userPredicate = [NSPredicate predicateWithFormat:@"ANY users == %@",masterUser];
        NSPredicate *positionPredicate = [NSPredicate predicateWithFormat:@"ensemble == %@",instrumentButton.parentPosition.ensemble];
        NSPredicate *compoundPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[userPredicate,positionPredicate]];
        NSArray *instrumentTypeArray = [XYPosition MR_findAllWithPredicate:compoundPredicate inContext:context];
        if ([instrumentTypeArray count] == 0) {
            
            //remove positions from users positions
            NSMutableSet *positionSet = [NSMutableSet setWithSet:[masterUser.positions mutableCopy]];
            for (XYPosition *position in positionSet) {
                if ([position isEqual:instrumentButton.parentPosition]) {
                    [positionSet removeObject:position];
                    break;
                }
            }
            masterUser.positions = positionSet;
        }
    }
    else {
        [instrumentButton.instrumentType addUsersObject:masterUser];
        [masterUser addPositionsObject:instrumentButton.parentPosition];
        
        instrumentButton.checked = YES;
    }
    
    NSManagedObjectContext *context = [NSManagedObjectContext MR_defaultContext];
    [context MR_saveOnlySelfAndWait];
    
    [self updatePositionButtonTitle:self.selectedPositionButton];
}

- (void)hideInstrumentButtonListForPositionButton:(XYPositionButton *)positionButton
{
    NSArray *subviews = self.scrollView.subviews;
    
    for (id view in subviews) {
        
        if ([view isKindOfClass:[XYInstrumentTypeButton class]]) {
            
            [UIView animateWithDuration:0.25f animations:^{
                ((XYInstrumentTypeButton *)view).topConstraint.constant = positionButton.topConstraint.constant;
                [self.scrollView layoutIfNeeded];
            } completion:^(BOOL finished) {
                [view removeFromSuperview];
            }];
        }
    }
    
#warning not finished!
    //    [self setupPositionButtonTitle:positionButton];
    
    [self performSelector:@selector(moveButtonToOriginalPosition:) withObject:positionButton afterDelay:0.35f];
}

#pragma mark - Helper functions

- (void)adjustNextButtonOffset:(int)offset withTarget:(SEL)selector
{
    self.nextButton.topConstraint.constant = offset;
    
    //remove and add correct actions
    [self.nextButton removeTarget:self action:@selector(selectButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.nextButton removeTarget:self action:@selector(nextButtonSelected) forControlEvents:UIControlEventTouchUpInside];
    [self.nextButton addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    
    //animate uichanges
    [self.scrollView setNeedsUpdateConstraints];
    [UIView animateWithDuration:0.2f animations:^{
        [self.scrollView setNeedsLayout];
    } completion:^(BOOL finished) {
    }];
    
    [self.view setNeedsLayout];
}

- (void)updateEnsembleButtonTitle:(XYEnsembleSelectionButton *)ensembleButton
{
    XYUser *masterUser = [XYUser masterUser];
    NSManagedObjectContext *context = [NSManagedObjectContext MR_defaultContext];
    NSPredicate *userPredicate = [NSPredicate predicateWithFormat:@"ANY users == %@",masterUser];
    NSPredicate *ensemblePredicate = [NSPredicate predicateWithFormat:@"ensemble == %@",ensembleButton.ensemble];
    NSPredicate *compoundPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[userPredicate,ensemblePredicate]];
    NSArray *positionArray = [XYPosition MR_findAllWithPredicate:compoundPredicate inContext:context];
    if ([positionArray count] == 0) {
        NSString *chooseYourPositionString = @"What is your role?";
        ensembleButton.roleTitle = chooseYourPositionString;
        ensembleButton.checked = NO;
    }
    else {
        NSMutableString *positionText = [NSMutableString stringWithFormat:@"You're a"];
        
        for (XYPosition *position in positionArray) {
            [positionText appendFormat:@" %@,",position.name];
        }
        positionText = [[positionText substringToIndex:(positionText.length - 1)] mutableCopy];
        [positionText appendString:@" here"];
        
        ensembleButton.roleTitle = positionText;
        ensembleButton.checked = YES;
    }
}

- (void)setupEnsembleButtonTitle:(XYEnsembleSelectionButton *)ensembleButton
{
    XYUser *masterUser = [XYUser masterUser];
    NSManagedObjectContext *context = [NSManagedObjectContext MR_defaultContext];
    NSPredicate *userPredicate = [NSPredicate predicateWithFormat:@"ANY users == %@",masterUser];
    NSPredicate *ensemblePredicate = [NSPredicate predicateWithFormat:@"ensemble == %@",ensembleButton.ensemble];
    NSPredicate *compoundPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[userPredicate,ensemblePredicate]];
    NSArray *positionArray = [XYPosition MR_findAllWithPredicate:compoundPredicate inContext:context];
    if ([positionArray count] == 0) {
        ensembleButton.roleTitle = nil;
        ensembleButton.checked = NO;
    }
    else {
        NSMutableString *positionText = [NSMutableString stringWithFormat:@"You're a"];
        
        for (XYPosition *position in positionArray) {
            [positionText appendFormat:@" %@,",position.name];
        }
        positionText = [[positionText substringToIndex:(positionText.length - 1)] mutableCopy];
        [positionText appendString:@" here"];
        
        ensembleButton.roleTitle = positionText;
        ensembleButton.checked = YES;
    }
}

- (void)setupPositionButtonTitle:(XYPositionButton *)positionButton
{
    XYUser *masterUser = [XYUser masterUser];
    NSManagedObjectContext *context = [NSManagedObjectContext MR_defaultContext];
    NSPredicate *userPredicate = [NSPredicate predicateWithFormat:@"ANY users == %@",masterUser];
    NSPredicate *ensemblePredicate = [NSPredicate predicateWithFormat:@"ANY ensembles == %@",positionButton.parentEnsemble];
    NSPredicate *compoundPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[userPredicate,ensemblePredicate]];
    NSArray *instrumentArray = [XYInstrumentType MR_findAllWithPredicate:compoundPredicate inContext:context];
    if ([instrumentArray count] == 0) {
        positionButton.roleTitle = nil;
        positionButton.checked = NO;
    }
    else {
        NSMutableString *positionText = [NSMutableString stringWithFormat:@"You play a"];
        
        for (XYInstrumentType *instrument in instrumentArray) {
            [positionText appendFormat:@" %@,",instrument.name];
        }
        positionText = [[positionText substringToIndex:(positionText.length - 1)] mutableCopy];
        [positionText appendString:@" here"];
        
        positionButton.roleTitle = positionText;
        positionButton.checked = YES;
    }
    
}

- (void)updatePositionButtonTitle:(XYPositionButton *)positionButton
{
    XYUser *masterUser = [XYUser masterUser];
    NSManagedObjectContext *context = [NSManagedObjectContext MR_defaultContext];
    NSPredicate *userPredicate = [NSPredicate predicateWithFormat:@"ANY users == %@",masterUser];
    NSPredicate *ensemblePredicate = [NSPredicate predicateWithFormat:@"ANY ensembles == %@",positionButton.parentEnsemble];
    NSPredicate *compoundPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[userPredicate,ensemblePredicate]];
    NSArray *instrumentArray = [XYInstrumentType MR_findAllWithPredicate:compoundPredicate inContext:context];
    if ([instrumentArray count] == 0) {
        NSString *chooseYourPositionString = @"What instruments do you play?";
        positionButton.roleTitle = chooseYourPositionString;
        positionButton.checked = NO;
    }
    else {
        NSMutableString *positionText = [NSMutableString stringWithFormat:@"You play a"];
        
        for (XYInstrumentType *instrument in instrumentArray) {
            [positionText appendFormat:@" %@,",instrument.name];
        }
        positionText = [[positionText substringToIndex:(positionText.length - 1)] mutableCopy];
        [positionText appendString:@" here"];
        
        positionButton.roleTitle = positionText;
        positionButton.checked = YES;
    }
}

@end

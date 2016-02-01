//
//  XYTextField.m
//  xylo
//
//  Created by Lukas Kekys on 05/03/14.
//  Copyright (c) 2014 Seriously. All rights reserved.
//

#import "XYTextField.h"

#define kRoundBackgroundOffsetFromTopAndBottom 5

@interface XYTextField () <UITextFieldDelegate>

@end

@implementation XYTextField

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self initialize];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initialize];
    }
    return self;
}

#pragma mark - View Initialize

- (void)initialize
{
    self.delegate = self;
    self.clipsToBounds = NO;

    self.font = [UIFont fontWithName:@"OpenSans" size:15.0];
    self.textColor = [UIColor colorWithRed:21.0f/255.0f green:29.0f/255.0f blue:31.0f/255.0f alpha:1.0f];
    self.borderStyle = UITextBorderStyleNone;
    self.textAlignment = NSTextAlignmentCenter;
    self.autocorrectionType = UITextAutocorrectionTypeNo;
    self.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.minimumFontSize = 15;
    self.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    self.layer.backgroundColor = [[UIColor whiteColor] CGColor];
    self.layer.cornerRadius = 2.0f;
    self.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.layer.shadowOffset = CGSizeMake(0,1);
    self.layer.shadowRadius = 3;
    self.layer.shadowOpacity = 0.1f;
}

#pragma mark - Helpers

- (void)viewSelected
{
    [self.xyTextFieldDelegate textFieldBecameActive:self];
    
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"shadowOpacity"];
    anim.duration = 0.3f;
    [self.layer addAnimation:anim forKey:@"shadowOpacity"];
    self.layer.shadowOpacity = 0.3f;
}

- (void)viewDeselected
{
    [self.xyTextFieldDelegate textFieldBecameInactive:self];
    
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"shadowOpacity"];
    anim.duration = 0.3f;
    [self.layer addAnimation:anim forKey:@"shadowOpacity"];
    self.layer.shadowOpacity = 0.1f;
}

#pragma mark - UITextfieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [self viewSelected];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self viewDeselected];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.xyTextFieldDelegate returnButtonSelectedInTextField:self];
    return YES;
}

@end

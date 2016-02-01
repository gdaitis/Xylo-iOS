//
//  XYTextField.h
//  xylo
//
//  Created by Lukas Kekys on 05/03/14.
//  Copyright (c) 2014 Seriously. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XYTextField;

@protocol XYTextFieldDelegate <NSObject>

@optional
- (void)returnButtonSelectedInTextField:(XYTextField *)textField;
- (void)textFieldBecameActive:(XYTextField *)textField;
- (void)textFieldBecameInactive:(XYTextField *)textField;

@end

@interface XYTextField : UITextField

@property (nonatomic, weak) id <XYTextFieldDelegate> xyTextFieldDelegate;

- (void)viewSelected;
- (void)viewDeselected;

@end

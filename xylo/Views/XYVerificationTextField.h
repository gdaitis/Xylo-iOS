//
//  XYVerificationTextField.h
//  xylo
//
//  Created by Lukas Kekys on 13/03/14.
//  Copyright (c) 2014 Seriously. All rights reserved.
//

#import "XYTextField.h"

@interface XYVerificationTextField : XYTextField

- (void)textValid;
- (void)textInvalid;
- (void)showActivityIndicator;
- (void)hideActivityIndicator;

@end

//
//  XYBaseRightArrowButton.h
//  xylo
//
//  Created by Lukas Kekys on 02/06/14.
//  Copyright (c) 2014 Seriously. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XYBaseRightArrowButton : UIButton

@property (nonatomic, strong) NSString *roleTitle;
@property (nonatomic, weak) UILabel *mainTitleLabel;
@property (nonatomic, assign) BOOL checked;

@property (nonatomic, assign) int originalTopContstraintConstant;
@property (nonatomic, strong) NSLayoutConstraint *topConstraint;

- (void)viewExpanded;
- (void)viewContracted;

@end

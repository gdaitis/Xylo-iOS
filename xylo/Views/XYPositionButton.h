//
//  XYPositionButton.h
//  xylo
//
//  Created by Lukas Kekys on 16/05/14.
//  Copyright (c) 2014 Seriously. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYBaseRightArrowButton.h"

@class XYPosition,XYEnsemble;

#define kXYPositionButton_ButtonWidth  264
#define kXYPositionButton_ButtonHeight 56

@interface XYPositionButton : XYBaseRightArrowButton

@property (nonatomic, strong) XYPosition *position;
@property (nonatomic, strong) XYEnsemble *parentEnsemble;

@end

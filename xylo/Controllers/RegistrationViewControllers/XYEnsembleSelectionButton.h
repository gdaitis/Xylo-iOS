//
//  XYEnsembleSelectionButton.h
//  xylo
//
//  Created by Lukas Kekys on 20/03/14.
//  Copyright (c) 2014 Seriously. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYBaseRightArrowButton.h"

@class XYEnsemble;

@interface XYEnsembleSelectionButton : XYBaseRightArrowButton

@property (nonatomic, strong) XYEnsemble *ensemble;

@end

//
//  XYInstrumentTypeButton.h
//  xylo
//
//  Created by Lukas Kekys on 20/06/14.
//  Copyright (c) 2014 Seriously. All rights reserved.
//

#import "XYBaseRightArrowButton.h"

@class XYEnsemble,XYPosition,XYInstrumentType;

@interface XYInstrumentTypeButton : XYBaseRightArrowButton

@property (nonatomic, strong) XYEnsemble *ensemble;
@property (nonatomic, strong) XYPosition *parentPosition;
@property (nonatomic, strong) XYInstrumentType *instrumentType;

@end

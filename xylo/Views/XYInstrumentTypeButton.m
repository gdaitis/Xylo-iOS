//
//  XYInstrumentTypeButton.m
//  xylo
//
//  Created by Lukas Kekys on 20/06/14.
//  Copyright (c) 2014 Seriously. All rights reserved.
//

#import "XYInstrumentTypeButton.h"
#import "XYPosition.h"
#import "XYInstrumentType.h"
#import "XYEnsemble.h"

@implementation XYInstrumentTypeButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setInstrumentType:(XYInstrumentType *)instrumentType
{
    _instrumentType = instrumentType;
    self.mainTitleLabel.text = instrumentType.name;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end

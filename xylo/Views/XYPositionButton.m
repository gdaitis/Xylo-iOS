//
//  XYPositionButton.m
//  xylo
//
//  Created by Lukas Kekys on 16/05/14.
//  Copyright (c) 2014 Seriously. All rights reserved.
//

#import "XYPositionButton.h"
#import "XYPosition.h"
#import "XYEnsemble.h"

@interface XYPositionButton ()

@end

@implementation XYPositionButton

- (void)setPosition:(XYPosition *)position
{
    _position = position;
    self.mainTitleLabel.text = position.name;
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

//
//  XYNavigationBarEditButton.m
//  xylo
//
//  Created by Lukas Kekys on 04/09/14.
//  Copyright (c) 2014 Seriously. All rights reserved.
//

#import "XYNavigationBarEditButton.h"

@implementation XYNavigationBarEditButton

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setupFonts];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setupFonts
{
    self.editButtonLabel.font = [UIFont fontWithName:@"OpenSans" size:18];
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

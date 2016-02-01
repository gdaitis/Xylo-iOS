//
//  XYTaskDefaultCell.m
//  xylo
//
//  Created by Lukas Kekys on 02/09/14.
//  Copyright (c) 2014 Seriously. All rights reserved.
//

#import "XYTaskDefaultCell.h"

@implementation XYTaskDefaultCell

- (void)awakeFromNib
{
    // Initialization code
    [self setupFonts];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setupFonts
{
    self.leftLabel.textColor = self.rightLabel.textColor = [UIColor colorWithRed:133.0f/255.0f green:161.0f/255.0f blue:165.0f/255.0f alpha:1];
    self.leftLabel.font = self.rightLabel.font = [UIFont fontWithName:@"OpenSans" size:13.0];
}

@end

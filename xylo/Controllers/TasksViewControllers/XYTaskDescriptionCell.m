//
//  XYTaskDescriptionCell.m
//  xylo
//
//  Created by Lukas Kekys on 03/09/14.
//  Copyright (c) 2014 Seriously. All rights reserved.
//

#import "XYTaskDescriptionCell.h"

@implementation XYTaskDescriptionCell

- (void)awakeFromNib
{
    // Initialization code
    [self setupFonts];
}

- (void)setupFonts
{
    self.nameLabel.textColor = [UIColor colorWithRed:21.0f/255.0f green:29.0f/255.0f blue:31.0f/255.0f alpha:1];
    self.nameLabel.font = [UIFont fontWithName:@"OpenSans" size:15.0];
    self.descriptionLabel.font = [UIFont fontWithName:@"OpenSans" size:13.0];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)setCompleted:(BOOL)completed
{
    _completed = completed;
    
    if (completed) {
        [self.checkboxButton setImage:[UIImage imageNamed:@"TaskBoxChecked"] forState:UIControlStateNormal];
    }
    else {
        [self.checkboxButton setImage:[UIImage imageNamed:@"TaskBoxUnchecked"] forState:UIControlStateNormal];
    }
}

@end


//self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, fixedWidth, 0);
//self.lineBreakMode = NSLineBreakByWordWrapping;
//self.numberOfLines = 0;
//[self sizeToFit];
//[myLabel sizeToFitFixedWidth:kSomeFixedWidth];
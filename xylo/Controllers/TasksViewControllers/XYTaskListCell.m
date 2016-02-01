//
//  XYTasksTableViewCell.m
//  xylo
//
//  Created by Lukas Kekys on 26/08/14.
//  Copyright (c) 2014 Seriously. All rights reserved.
//

#import "XYTaskListCell.h"
#import "XYTasksButton.h"

@implementation XYTaskListCell

- (void)setMarked:(BOOL)marked
{
    _marked = marked;
    
    if (marked) {
        [self.favoriteButton setImage:[UIImage imageNamed:@"TaskCellFavoriteIconMarked"] forState:UIControlStateNormal];
    }
    else {
        [self.favoriteButton setImage:[UIImage imageNamed:@"TaskCellFavoriteIconUnmarked"] forState:UIControlStateNormal];
    }
    
}

- (void)setRecuring:(BOOL)recuring
{
    _recuring = recuring;
    
    if (recuring) {
        self.recuringImageView.hidden = NO;
    }
    else {
        self.recuringImageView.hidden = YES;
    }
}

- (void)setCompleted:(BOOL)completed
{
    _completed = completed;
    
    if (completed) {
        self.backgroundColor = [UIColor colorWithRed:189.0f/255.0f green:201.0f/255.0f blue:207.0f/255.0f alpha:1.0f];
        [self.checkboxButton setImage:[UIImage imageNamed:@"TaskBoxChecked"] forState:UIControlStateNormal];
    }
    else {
        self.backgroundColor = [UIColor whiteColor];
        [self.checkboxButton setImage:[UIImage imageNamed:@"TaskBoxUnchecked"] forState:UIControlStateNormal];
    }
}

- (void)awakeFromNib
{
    // Initialization code
    [self setupCell];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
    
}

- (void)setupCell
{
    self.dayLabel.font = [UIFont fontWithName:@"OpenSans-Semibold" size:11];
    self.descriptionLabel.font = [UIFont fontWithName:@"OpenSans" size:15];
}

@end

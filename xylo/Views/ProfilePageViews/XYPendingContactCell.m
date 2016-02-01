//
//  XYPendingContactCell.m
//  xylo
//
//  Created by Lukas Kekys on 15/04/14.
//  Copyright (c) 2014 Seriously. All rights reserved.
//

#import "XYPendingContactCell.h"

@interface XYPendingContactCell ()

@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *instrumentLabel;
@property (nonatomic, weak) IBOutlet UIImageView *contactImageView;

@end

@implementation XYPendingContactCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

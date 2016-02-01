//
//  XYOrganizationSocialCell.m
//  xylo
//
//  Created by Lukas Kekys on 15/04/14.
//  Copyright (c) 2014 Seriously. All rights reserved.
//

#import "XYOrganizationSocialCell.h"

@interface XYOrganizationSocialCell ()

@property (nonatomic, weak) IBOutlet UILabel *dateLabel;
@property (nonatomic, weak) IBOutlet UILabel *socialNetworkLabel;
@property (nonatomic, weak) IBOutlet UILabel *messageLabel;
@property (nonatomic, weak) IBOutlet UIImageView *socialIconImageView;

@end

@implementation XYOrganizationSocialCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self initialize];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self initialize];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)initialize
{
    self.dateLabel.font = [UIFont fontWithName:@"OpenSans-Semibold" size:9];
    self.socialNetworkLabel.font = [UIFont fontWithName:@"OpenSans" size:9];
    self.messageLabel.font = [UIFont fontWithName:@"OpenSans" size:11];
}

- (void)populateCellWithSocialData:(id)socialData
{
    self.dateLabel.text = [socialData valueForKey:@"date"];
    self.socialNetworkLabel.text = [socialData valueForKey:@"socialNetwork"];
    self.messageLabel.text = [socialData valueForKey:@"socialText"];
}

@end

//
//  XYOrganizationContactInfoCell.m
//  xylo
//
//  Created by Lukas Kekys on 09/04/14.
//  Copyright (c) 2014 Seriously. All rights reserved.
//

#import "XYOrganizationContactInfoCell.h"
#import "XYOrganization.h"
#import "XYEnsemble.h"

@interface XYOrganizationContactInfoCell ()

@property (nonatomic, weak) IBOutlet UILabel *leftLabel;
@property (nonatomic, weak) IBOutlet UILabel *rightLabel;

@end

@implementation XYOrganizationContactInfoCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self initialSetup];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self initialSetup];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)initialSetup
{
    self.leftLabel.font = [UIFont fontWithName:@"OpenSans-Bold" size:11];
    self.rightLabel.font = [UIFont fontWithName:@"OpenSans" size:11];
}

- (void)populateCellWithOrganization:(XYOrganization *)organization forIndexPathRow:(NSInteger)row
{
    NSString *leftString = nil;
    NSString *rightString = nil;
    
    if (row == 0) {
        leftString = @"Director";
        rightString = organization.director;
    }
    else if (row == 1) {
        leftString = @"Website";
        rightString = organization.website;
    }
    else if (row == 2) {
        leftString = @"Phone";
        rightString = organization.phone;
    }
    else if (row == 3) {
        leftString = @"Address";
        rightString = organization.firstAddress;
    }
    else {
        leftString = @"Booster";
        rightString = organization.boosters;
    }
    
    self.leftLabel.text = leftString;
    self.rightLabel.text = rightString;
}

- (void)populateCellWithEnsemble:(XYEnsemble *)ensemble forIndexPathRow:(NSInteger)row
{
    NSString *leftString = nil;
    NSString *rightString = nil;
    
    if (row == 0) {
        leftString = @"Director";
        rightString = @"";
    }
    else if (row == 1) {
        leftString = @"Website";
        rightString = ensemble.website;
    }
    else if (row == 2) {
        leftString = @"Phone";
        rightString = ensemble.phone;
    }
    else if (row == 3) {
        leftString = @"Address";
//        rightString = ensemble.firstAddress;
    }
    else {
        leftString = @"Booster";
//        rightString = organization.boosters;
    }
    
    self.leftLabel.text = leftString;
    self.rightLabel.text = rightString;
}



@end

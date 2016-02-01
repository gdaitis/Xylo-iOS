//
//  XYOrganizationMemberCell.m
//  xylo
//
//  Created by Lukas Kekys on 15/04/14.
//  Copyright (c) 2014 Seriously. All rights reserved.
//

#import "XYOrganizationMemberCell.h"
#import "XYUser+UserFunctions.h"
#import <UIImageView+AFNetworking.h>

@interface XYOrganizationMemberCell ()

@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *instrumentLabel;
@property (nonatomic, weak) IBOutlet UIImageView *memberImageView;

@end

@implementation XYOrganizationMemberCell

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

- (void)setupCellWithUser:(XYUser *)user
{
    NSMutableString *string = [NSMutableString stringWithString:user.firstName];
    if (user.lastName.length > 0)
        [string appendFormat:@" %@",user.lastName];
    
    self.nameLabel.text = string;
    
    self.memberImageView.image = nil;
    
    [self.memberImageView setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:user.logoImageUrl]] placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        [self.memberImageView setImage:image];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        
    }];
}

@end

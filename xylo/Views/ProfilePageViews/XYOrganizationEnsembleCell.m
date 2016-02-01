//
//  XYOrganizationEnsembleCell.m
//  xylo
//
//  Created by Lukas Kekys on 09/04/14.
//  Copyright (c) 2014 Seriously. All rights reserved.
//

#import "XYOrganizationEnsembleCell.h"
#import "XYEnsemble.h"
#import "XYUser+UserFunctions.h"
#import <UIImageView+AFNetworking.h>
#import "XYEnsembleType.h"

@interface XYOrganizationEnsembleCell ()

@property (nonatomic, weak) IBOutlet UILabel *ensembleTitleLabel;
@property (nonatomic, weak) IBOutlet UILabel *subtitleLabel;
@property (nonatomic, weak) IBOutlet UILabel *roleLabel;
@property (nonatomic, weak) IBOutlet UIImageView *ensembleImageView;

@end

@implementation XYOrganizationEnsembleCell

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
    self.ensembleTitleLabel.font = [UIFont fontWithName:@"OpenSans-Semibold" size:14];
    self.subtitleLabel.font = [UIFont fontWithName:@"OpenSans-Semibold" size:9];
    self.roleLabel.font = [UIFont fontWithName:@"OpenSans-Semibold" size:9];
    self.subtitleLabel.textColor = [UIColor colorWithRed:167.0/255.0 green:191.0/255.0 blue:203.0/255.0 alpha:1.0];
    self.roleLabel.textColor = [UIColor colorWithRed:167.0/255.0 green:191.0/255.0 blue:203.0/255.0 alpha:1.0];
}

- (void)populateCellWithEnsembleData:(XYEnsemble *)ensemble
{
    self.ensembleTitleLabel.text = ensemble.name;
    self.subtitleLabel.text = ensemble.ensembleType.ensembleTypeName;
    
#warning should we show member or not?
//    BOOL userBelongsToEnsemble = [XYUser masterUserBelongsToEnsemble:ensemble];
//    self.roleLabel.text = (userBelongsToEnsemble) ? @"Member" : @"";
    self.roleLabel.text = @"";
    
    self.ensembleImageView.image = nil;
    [self.ensembleImageView cancelImageRequestOperation];
    
    [self.ensembleImageView setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:ensemble.logoImageUrl]] placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        [self.ensembleImageView setImage:image];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        
    }];
}

@end

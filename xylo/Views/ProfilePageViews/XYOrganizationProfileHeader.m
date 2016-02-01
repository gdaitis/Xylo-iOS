//
//  XYOrganizationProfileHeader.m
//  xylo
//
//  Created by Lukas Kekys on 08/04/14.
//  Copyright (c) 2014 Seriously. All rights reserved.
//

#import "XYOrganizationProfileHeader.h"
#import "XYOrganization.h"
#import <UIImageView+AFNetworking.h>

@interface XYOrganizationProfileHeader ()

@property (nonatomic, weak) IBOutlet UIImageView *logoImageView;
@property (nonatomic, weak) IBOutlet UIImageView *backgroundImageView;

@end

@implementation XYOrganizationProfileHeader

- (void)setupHeaderWithOrganization:(XYOrganization *)organization
{    
    if (organization.logoImageUrl.length > 1) {
//        [self.logoImageView setImageWithURL:[NSURL URLWithString:organization.logoImageUrl]];
        
        [self.logoImageView setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:organization.logoImageUrl]] placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
            [self.logoImageView setImage:image];
            NSLog(@"logo image loaded");
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
            NSLog(@"logo image FAILED");
        }];
    }
    if (organization.coverImageUrl.length > 1) {
//        [self.backgroundImageView setImageWithURL:[NSURL URLWithString:organization.coverImageUrl]];
    
        [self.backgroundImageView setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:organization.coverImageUrl]] placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
            [self.backgroundImageView setImage:image];
            NSLog(@"cover image loaded");
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
            NSLog(@"cover image FAILED");
        }];
    }
}

@end

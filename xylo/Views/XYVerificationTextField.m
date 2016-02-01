//
//  XYVerificationTextField.m
//  xylo
//
//  Created by Lukas Kekys on 13/03/14.
//  Copyright (c) 2014 Seriously. All rights reserved.
//

#import "XYVerificationTextField.h"

@interface XYVerificationTextField ()

@property (nonatomic, weak) UIImageView *validationImageView;
@property (nonatomic, weak) UIActivityIndicatorView *activityIndicatorView;

@end

@implementation XYVerificationTextField

- (void)viewSelected
{
    [super viewSelected];
    [self clearVerificationIcons];
    [self hideActivityIndicator];
}

- (void)clearVerificationIcons
{
    [self.validationImageView removeFromSuperview];
}

- (void)textValid
{
    [self hideActivityIndicator];
    [self clearVerificationIcons];
    [self addValidationViewWithImage:[UIImage imageNamed:@"ValidEmailIcon.png"]];
}

- (void)textInvalid
{
    [self hideActivityIndicator];
    [self clearVerificationIcons];
    [self addValidationViewWithImage:[UIImage imageNamed:@"InvalidEmailIcon.png"]];
}

- (void)showActivityIndicator
{
    [self hideActivityIndicator];
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    int imageOffset = 7;
    int imagePositionX = self.bounds.size.width - activityIndicator.bounds.size.height - imageOffset;
    int imagePositionY = (self.bounds.size.height/2) - (activityIndicator.bounds.size.height/2);
    
    self.activityIndicatorView = activityIndicator;
    CGRect frame = self.activityIndicatorView.frame;
    frame.origin.x = imagePositionX;
    frame.origin.y = imagePositionY;
    self.activityIndicatorView.frame = frame;
    [self addSubview:self.activityIndicatorView];
    [self.activityIndicatorView startAnimating];
}

- (void)hideActivityIndicator
{
    if (self.activityIndicatorView) {
        [self.activityIndicatorView removeFromSuperview];
        self.activityIndicatorView = nil;
    }
}

- (void)addValidationViewWithImage:(UIImage *)image
{
    int imageOffset = 7;
    int imagePositionX = self.bounds.size.width - image.size.height - imageOffset;
    int imagePositionY = (self.bounds.size.height/2) - (image.size.height/2);
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(imagePositionX, imagePositionY, image.size.width, image.size.height)];
    self.validationImageView = imageView;
    self.validationImageView.image = image;
    
    [self addSubview:self.validationImageView];
}

@end

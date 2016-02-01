//
//  XYBaseRightArrowButton.m
//  xylo
//
//  Created by Lukas Kekys on 02/06/14.
//  Copyright (c) 2014 Seriously. All rights reserved.
//

#import "XYBaseRightArrowButton.h"

#define kXYEnsembleSelectionButtonShadowHeight 15

NSString * const kXYEnsembleSelectionButtonArrowImage = @"EnsembleSelectionNextArrow.png";
NSString * const kXYEnsembleSelectionButtonCheckmarkImage = @"EnsembleSelectionCheckmarkImage.png";

@interface XYBaseRightArrowButton ()

@property (nonatomic, weak) UIImageView *arrowImageView;
@property (nonatomic, weak) UILabel *roleLabel;
@property (nonatomic, strong) CAGradientLayer *shadow;

@end

@implementation XYBaseRightArrowButton

@synthesize checked = _checked;

- (void)setChecked:(BOOL)checked
{
    _checked = checked;
    
    if (checked) {
        self.arrowImageView.image = [UIImage imageNamed:kXYEnsembleSelectionButtonCheckmarkImage];
        //set rotated image to normal position
        self.arrowImageView.transform = CGAffineTransformMakeRotation(0);
    }
    else
        self.arrowImageView.image = [UIImage imageNamed:kXYEnsembleSelectionButtonArrowImage];
}

- (void)setRoleTitle:(NSString *)roleTitle
{
    if (roleTitle) {
        if (!self.roleLabel) {
            //adding role label
            UILabel *roleLabel = [[UILabel alloc] init];
            [roleLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
            [self addSubview:roleLabel];
            self.roleLabel = roleLabel;
            self.roleLabel.font = [UIFont fontWithName:@"OpenSans" size:12.0];
            self.roleLabel.textColor = [UIColor grayColor];
            self.roleLabel.numberOfLines = 1;
            self.roleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
            self.roleLabel.preferredMaxLayoutWidth = 200;
            
            [self.roleLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
            [self.roleLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
            
            
            //first we add label lower to the view
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[ensembleTitleLabel]-0-[roleLabel]"
                                                                         options:0
                                                                         metrics:nil
                                                                           views:@{@"roleLabel" : self.roleLabel,
                                                                                   @"ensembleTitleLabel" : self.mainTitleLabel}]];
            
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[roleLabel]-[arrowImageView]"
                                                                         options:0
                                                                         metrics:nil
                                                                           views:@{@"arrowImageView" : self.arrowImageView,
                                                                                   @"roleLabel" : self.roleLabel}]];
            
            self.roleLabel.alpha = 0.0f;
            [self layoutIfNeeded];
            
            //later we lift up the label to its position for animating purposes
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[ensembleTitleLabel]-0-[roleLabel]-10-|"
                                                                         options:0
                                                                         metrics:nil
                                                                           views:@{@"roleLabel" : self.roleLabel,
                                                                                   @"ensembleTitleLabel" : self.mainTitleLabel}]];
            
            [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self.roleLabel.alpha = 1.0f;
                [self layoutIfNeeded];
            } completion:^(__unused BOOL finished) {
            }];
        }
        self.roleLabel.text = roleTitle;
    }
    else {
        [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.roleLabel.alpha = 0.0f;
        } completion:^(__unused BOOL finished) {
        }];
        [self.roleLabel removeFromSuperview];
    }
}

- (id)init
{
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initialize];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self initialize];
}

- (void)initialize
{
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = 3.0f;
    self.layer.masksToBounds = YES;
    self.clipsToBounds = YES;
    
    [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    //adding arrow imageview on the right with constraints
    UIImageView *arrowImageView = [UIImageView new];
    self.arrowImageView = arrowImageView;
    UIImage *arrowImage = [UIImage imageNamed:kXYEnsembleSelectionButtonArrowImage];
    self.arrowImageView.image = arrowImage;
    
    [self.arrowImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addSubview: self.arrowImageView];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[arrowImageView]-10-|"
                                                                 options:0
                                                                 metrics:nil
                                                                   views:@{@"arrowImageView" : self.arrowImageView}]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.arrowImageView
                                                     attribute:NSLayoutAttributeCenterY
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeCenterY
                                                    multiplier:1.0
                                                      constant:0.0]];
    // Pin Width & Height
    [self.arrowImageView addConstraint:[NSLayoutConstraint constraintWithItem:self.arrowImageView
                                                                    attribute:NSLayoutAttributeWidth
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:nil
                                                                    attribute:NSLayoutAttributeNotAnAttribute
                                                                   multiplier:1.0f
                                                                     constant:arrowImage.size.width]];
    
    [self.arrowImageView addConstraint:[NSLayoutConstraint constraintWithItem:self.arrowImageView
                                                                    attribute:NSLayoutAttributeHeight
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:nil
                                                                    attribute:NSLayoutAttributeNotAnAttribute
                                                                   multiplier:1.0f
                                                                     constant:arrowImage.size.height]];
    
    //adding ensemble title label
    UILabel *titleLabel = [[UILabel alloc] init];
    [self addSubview:titleLabel];
    [titleLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    self.mainTitleLabel = titleLabel;
    self.mainTitleLabel.font = [UIFont fontWithName:@"OpenSans" size:15.0];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[ensembleTitleLabel]-[arrowImageView]"
                                                                 options:0
                                                                 metrics:nil
                                                                   views:@{@"arrowImageView" : self.arrowImageView,
                                                                           @"ensembleTitleLabel" : self.mainTitleLabel}]];
    
    NSLayoutConstraint *ensembleLabelCenterConstraint = [NSLayoutConstraint constraintWithItem:self.mainTitleLabel
                                                                                     attribute:NSLayoutAttributeCenterY
                                                                                     relatedBy:NSLayoutRelationEqual
                                                                                        toItem:self
                                                                                     attribute:NSLayoutAttributeCenterY
                                                                                    multiplier:1.0
                                                                                      constant:0.0];
    [self.mainTitleLabel addConstraint:[NSLayoutConstraint constraintWithItem:self.mainTitleLabel
                                                                        attribute:NSLayoutAttributeHeight
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:nil
                                                                        attribute:NSLayoutAttributeNotAnAttribute
                                                                       multiplier:1.0f
                                                                         constant:20]];
    
    ensembleLabelCenterConstraint.priority = 950;
    [self addConstraint:ensembleLabelCenterConstraint];
}

- (void)viewExpanded
{
    [self addShadowAnimated];
    //if user reselects role, we don't need to rotate checkmark image
    if (![UIImagePNGRepresentation(self.arrowImageView.image) isEqual:UIImagePNGRepresentation([UIImage imageNamed:kXYEnsembleSelectionButtonCheckmarkImage])]) {
        [UIView animateWithDuration:0.25f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
            float degrees = 90; //the value in degrees
            self.arrowImageView.transform = CGAffineTransformMakeRotation(degrees * M_PI/180);
        } completion:^(__unused BOOL finished) {
        }];
    }
}

- (void)viewContracted
{
    [self removeShadowAnimated];
    [UIView animateWithDuration:0.25f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.arrowImageView.transform = CGAffineTransformMakeRotation(0);
    } completion:^(__unused BOOL finished) {
    }];
}

- (void)addShadowAnimated
{
    if (!self.shadow) {
        
        CGColorRef darkColor = [[UIColor blackColor] colorWithAlphaComponent:0.25f].CGColor;
        CGColorRef lightColor = [UIColor clearColor].CGColor;
        
        CAGradientLayer *newShadow = [[CAGradientLayer alloc] init];
        newShadow.frame = CGRectMake(0, self.frame.size.height-kXYEnsembleSelectionButtonShadowHeight, self.frame.size.width, kXYEnsembleSelectionButtonShadowHeight);
        newShadow.colors = [NSArray arrayWithObjects:(__bridge id)lightColor, (__bridge id)darkColor, nil];
        newShadow.hidden = YES;
        [self.layer addSublayer:newShadow];
        
        
        CATransition* transition = [CATransition animation];
        transition.startProgress = 0;
        transition.endProgress = 1.0;
        transition.type = kCATransitionFade;
        transition.duration = 0.3;
        
        // Add the transition animation to both layers
        [self.layer addAnimation:transition forKey:@"transition"];
        
        newShadow.hidden = NO;
        self.shadow = newShadow;
    }
}


- (void)removeShadowAnimated
{
    if (self.shadow) {
        CATransition* transition = [CATransition animation];
        transition.startProgress = 0;
        transition.endProgress = 1.0;
        transition.type = kCATransitionFade;
        transition.duration = 0.3;
        
        [CATransaction setCompletionBlock:^{
            [self.shadow removeFromSuperlayer];
            self.shadow = nil;
        }];
        
        // Add the transition animation to both layers
        [self.layer addAnimation:transition forKey:@"transition"];
        
        self.shadow.hidden = YES;
    }
}

@end

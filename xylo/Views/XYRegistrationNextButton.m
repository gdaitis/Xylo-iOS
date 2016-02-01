//
//  XYRegistrationNextButton.m
//  xylo
//
//  Created by lite on 03/03/14.
//  Copyright (c) 2014 Seriously. All rights reserved.
//

#import "XYRegistrationNextButton.h"
#import "UIView+NibLoading.h"

#define kXYRegistrationNextButtonWidthAndHeight 72

#define DEGREES_TO_RADIANS(degrees) ((M_PI * degrees)/ 180)

NSString * const kXYRegistrationNextButtonPulsationAnimationKey = @"XYRegistrationNextButtonPulsationAnimationKey";
NSString * const kXYRegistrationNextButtonRotationAnimationKey = @"XYRegistrationNextButtonRotationAnimationKey";

@interface XYRegistrationNextButton ()

@property (nonatomic, strong) CALayer *circleLayer;
@property (nonatomic, strong) CAShapeLayer *arcLayer;
@property (nonatomic, strong) UIImageView *arrowImageView;
@property (nonatomic, strong) UILabel *yesLabel;

@end

@implementation XYRegistrationNextButton

#pragma mark - Init methods

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self initialize];
}

#pragma mark - View Initialize

- (void)initialize
{
    CGRect frame = self.frame;
    frame.size = CGSizeMake(kXYRegistrationNextButtonWidthAndHeight, kXYRegistrationNextButtonWidthAndHeight);
    self.frame = frame;
    
    // Circle
    CAShapeLayer *circleLayer = [CAShapeLayer layer];
    circleLayer.bounds = CGRectMake(0.0f,
                                    0.0f,
                                    kXYRegistrationNextButtonWidthAndHeight,
                                    kXYRegistrationNextButtonWidthAndHeight);
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0.0f,
                                                                           0.0f,
                                                                           kXYRegistrationNextButtonWidthAndHeight,
                                                                           kXYRegistrationNextButtonWidthAndHeight)];
    circleLayer.path = [path CGPath];
    circleLayer.strokeColor = [[UIColor whiteColor] CGColor];
    circleLayer.lineWidth = 2.0f;
    circleLayer.fillColor = [[UIColor clearColor] CGColor];
    
    [self.layer addSublayer:circleLayer];
    self.circleLayer = circleLayer;
    
    // Arrow
    
    UIImage *arrowImage = [UIImage imageNamed:@"nextArrow"];
    UIImageView *arrowImageView = [[UIImageView alloc] initWithImage:arrowImage];
    [self addSubview:arrowImageView];
    self.arrowImageView = arrowImageView;
    
    // Arc
    
    int radius = (kXYRegistrationNextButtonWidthAndHeight / 2);
    CAShapeLayer *arc = [CAShapeLayer layer];
    arc.path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(0, 0)
                                              radius:radius
                                          startAngle:0.0
                                            endAngle:DEGREES_TO_RADIANS(350)
                                           clockwise:YES].CGPath;
    
    arc.fillColor = circleLayer.fillColor;
    arc.strokeColor = circleLayer.strokeColor;
    arc.lineWidth = circleLayer.lineWidth;
    arc.hidden = YES;
    
    [self.layer addSublayer:arc];
    self.arcLayer = arc;
    
    // YES label
    
    self.yesLabel = [[UILabel alloc] init];
    NSString *yesString = @"YES";
    self.yesLabel.text = yesString;
    self.yesLabel.textColor = [UIColor whiteColor];
    self.yesLabel.font = [UIFont fontWithName:@"OpenSans-Bold" size:12];
    [self.yesLabel sizeToFit];
    self.yesLabel.alpha = 0;
    [self addSubview:self.yesLabel];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect imageViewFrame = self.arrowImageView.frame;
    imageViewFrame.origin = CGPointMake(25, 27);
    self.arrowImageView.frame = imageViewFrame;
    
    self.circleLayer.position = CGPointMake(kXYRegistrationNextButtonWidthAndHeight/2,
                                            kXYRegistrationNextButtonWidthAndHeight/2);
    
    self.arcLayer.position = self.circleLayer.position;
    self.yesLabel.center = CGPointMake(kXYRegistrationNextButtonWidthAndHeight/2, kXYRegistrationNextButtonWidthAndHeight/2);
}

#pragma mark - Methods

- (void)startPulsating
{
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.duration = 1.5f;
    animationGroup.repeatCount = INFINITY;
    
    CAMediaTimingFunction *easeOut = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    CAKeyframeAnimation *pulseAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale.xy"];
    pulseAnimation.keyTimes = @[@0.0f, @0.1f, @0.2f, @1.5f];
    pulseAnimation.values = @[@1.0f, @1.1f, @1.0f, @1.0f];
    pulseAnimation.timingFunction = easeOut;
    
    animationGroup.animations = @[pulseAnimation];
    
    [self.circleLayer addAnimation:animationGroup
                            forKey:kXYRegistrationNextButtonPulsationAnimationKey];
    self.pulsating = YES;
}

- (void)pausePulsating
{
    [self.circleLayer removeAnimationForKey:kXYRegistrationNextButtonPulsationAnimationKey];
    
    self.pulsating = NO;
}

- (void)startLoadingIndicator
{
    self.arrowImageView.alpha = 0;
    self.circleLayer.hidden = YES;
    self.arcLayer.hidden = NO;
    self.yesLabel.alpha = 0;
    
    CABasicAnimation *rotateAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    rotateAnimation.toValue = @(M_PI*2);
    rotateAnimation.duration = 1.0f;
    rotateAnimation.repeatCount = INFINITY;
    
    [self.arcLayer addAnimation:rotateAnimation
                         forKey:kXYRegistrationNextButtonRotationAnimationKey];
    
    self.loading = YES;
}

- (void)pauseLoadingIndicator
{
    self.arrowImageView.alpha = 1;
    self.circleLayer.hidden = NO;
    self.arcLayer.hidden = YES;
    self.yesLabel.alpha = 0;
    
    [self.arcLayer removeAnimationForKey:kXYRegistrationNextButtonRotationAnimationKey];
    
    self.loading = NO;
}

- (void)changeToYesButton
{
    self.arrowImageView.alpha = 0;
    self.yesLabel.alpha = 1;
    self.circleLayer.hidden = NO;
    self.arcLayer.hidden = YES;
    
    [self.circleLayer removeAnimationForKey:kXYRegistrationNextButtonPulsationAnimationKey];
    [self.arcLayer removeAnimationForKey:kXYRegistrationNextButtonRotationAnimationKey];
}

- (void)changeToSelectButton
{
    self.arrowImageView.alpha = 0;
    NSString *selectString = @"SELECT";
    self.yesLabel.text = selectString;
    [self.yesLabel sizeToFit];
    self.yesLabel.alpha = 1;
    self.circleLayer.hidden = NO;
    self.arcLayer.hidden = YES;
    
    [self.circleLayer removeAnimationForKey:kXYRegistrationNextButtonPulsationAnimationKey];
    [self.arcLayer removeAnimationForKey:kXYRegistrationNextButtonRotationAnimationKey];
}

- (void)changeToNextButton
{
    self.arrowImageView.alpha = 1;
    self.yesLabel.alpha = 0;
    self.circleLayer.hidden = NO;
    self.arcLayer.hidden = YES;
    
    [self.circleLayer removeAnimationForKey:kXYRegistrationNextButtonPulsationAnimationKey];
    [self.arcLayer removeAnimationForKey:kXYRegistrationNextButtonRotationAnimationKey];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end

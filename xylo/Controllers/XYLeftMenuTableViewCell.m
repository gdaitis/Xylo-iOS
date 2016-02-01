//
//  XYLeftMenuTableViewCell.m
//  xylo
//
//  Created by lite on 08/05/14.
//  Copyright (c) 2014 Seriously. All rights reserved.
//

/*
 http://stackoverflow.com/questions/18746929/using-auto-layout-in-uitableview-for-dynamic-cell-layouts-variable-row-heights
 */

#import "XYLeftMenuTableViewCell.h"
#import "XYRootViewController.h"
#import <UIImageView+AFNetworking.h>

#define kXYLeftMenuTableViewCellBadgeViewHeight 22

@interface XYLeftMenuTableViewCell ()

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) NSMutableArray *customConstraints;
@property (nonatomic, strong) UIView *badgeView;
@property (nonatomic, strong) CAShapeLayer *badgeCircleLayer;
@property (assign) NSInteger badgeNumber;
@property (nonatomic, strong) UILabel *badgeNumberLabel;
@property (nonatomic, assign) BOOL isFirstInTheList;
@property (nonatomic, strong) UIImage *activeImage;
@property (nonatomic, strong) UIImage *inactiveImage;

@end

@implementation XYLeftMenuTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        self.backgroundView.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor colorWithRed:49.0f/255.0f green:56.0f/255.0f blue:60.0f/255.0f alpha:1];
        
        [self setupIconImageView];
        [self setupBadgeView];
        [self setupTitleLabel];
        [self setupBottomLine];
        
#warning hidden badgeView
        self.badgeView.hidden = YES;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    if (selected) {
        self.contentView.backgroundColor = [UIColor colorWithRed:42.0f/255.0f green:48.0f/255.0f blue:52.0f/255.0f alpha:1];
        self.titleLabel.textColor = [UIColor whiteColor];
        self.badgeNumberLabel.textColor = [UIColor whiteColor];
        self.badgeCircleLayer.strokeColor = [[UIColor whiteColor] CGColor];
        self.iconImageView.image = self.activeImage;
    } else {
        self.contentView.backgroundColor = [UIColor colorWithRed:49.0f/255.0f green:56.0f/255.0f blue:60.0f/255.0f alpha:1];
        self.titleLabel.textColor = [UIColor colorWithRed:133.0f/255.0f green:161.0f/255.0f blue:165.0f/255.0f alpha:1];
        self.badgeNumberLabel.textColor = [UIColor colorWithRed:133.0f/255.0f green:161.0f/255.0f blue:165.0f/255.0f alpha:1];
        self.badgeCircleLayer.strokeColor = [[UIColor colorWithRed:128.0f/255.0f green:155.0f/255.0f blue:159.0f/255.0f alpha:1] CGColor];
        self.iconImageView.image = self.inactiveImage;
    }
    self.backgroundView.backgroundColor = [UIColor clearColor];
    self.selectedBackgroundView.backgroundColor = [UIColor clearColor];
    
}

- (void)updateConstraints
{
    [super updateConstraints];
    
    NSInteger badgeWidthConstant;
    if (self.badgeNumber != 0) {
        badgeWidthConstant = kXYLeftMenuTableViewCellBadgeViewHeight;
        
        self.badgeView.alpha = 1;
        
        [self.titleLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:self.badgeView withOffset:-10];
    } else {
        badgeWidthConstant = 0;
        
        self.badgeView.alpha = 0;
        
        [self.titleLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:23];
    }
    [self.badgeView autoSetDimension:ALDimensionWidth toSize:badgeWidthConstant];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.isFirstInTheList) {
        CALayer *topLine = [[CALayer alloc] init];
        topLine.frame = CGRectMake(0, -1, self.bounds.size.width, 1);
        topLine.backgroundColor = [UIColor colorWithRed:38.0f/255.0f green:44.0f/255.0f blue:48.0f/255.0f alpha:1].CGColor;;
        [self.layer addSublayer:topLine];
    }
}

#pragma mark - Subviews setup

- (void)setupIconImageView
{
    self.iconImageView = [UIImageView newAutoLayoutView];
    self.iconImageView.backgroundColor = [UIColor colorWithRed:29.0f/255.0f green:33.0f/255.0f blue:35.0f/255.0f alpha:1];
    [self.contentView addSubview:self.iconImageView];
    
    [self.iconImageView autoSetDimension:ALDimensionWidth toSize:35];
    //[self.iconImageView autoSetDimension:ALDimensionHeight toSize:35]; // commented out due to the bug of cells vertical alignment http://stackoverflow.com/questions/21099087/autolayout-constraint-issue-with-unexpected-nsautoresizingmasklayoutconstraint
    [self.iconImageView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:10];
    [self.iconImageView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:10];
    [self.iconImageView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:12];
}

- (void)setupTitleLabel
{
    self.titleLabel = [UILabel newAutoLayoutView];
    self.titleLabel.font = [UIFont fontWithName:@"OpenSans" size:14];
    self.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    self.titleLabel.textColor = [UIColor colorWithRed:133.0f/255.0f green:161.0f/255.0f blue:165.0f/255.0f alpha:1];
    self.titleLabel.numberOfLines = 1;
    [self.contentView addSubview:self.titleLabel];
    
    [UIView autoSetPriority:UILayoutPriorityDefaultLow forConstraints:^{
        [self.titleLabel autoSetContentCompressionResistancePriorityForAxis:ALAxisHorizontal];
    }];
    [self.titleLabel autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.iconImageView];
    [self.titleLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.iconImageView withOffset:14];
}

- (void)setupBadgeView
{
    self.badgeView = [UIView newAutoLayoutView];
    self.badgeView.backgroundColor = [UIColor clearColor];
    
    self.badgeCircleLayer = [CAShapeLayer layer];
    self.badgeCircleLayer.bounds = CGRectMake(0.0f,
                                              0.0f,
                                              kXYLeftMenuTableViewCellBadgeViewHeight,
                                              kXYLeftMenuTableViewCellBadgeViewHeight);
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(kXYLeftMenuTableViewCellBadgeViewHeight/2,
                                                                           kXYLeftMenuTableViewCellBadgeViewHeight/2,
                                                                           kXYLeftMenuTableViewCellBadgeViewHeight,
                                                                           kXYLeftMenuTableViewCellBadgeViewHeight)];
    self.badgeCircleLayer.path = [path CGPath];
    self.badgeCircleLayer.strokeColor = [[UIColor colorWithRed:128.0f/255.0f green:155.0f/255.0f blue:159.0f/255.0f alpha:1] CGColor];
    self.badgeCircleLayer.lineWidth = 1.0f;
    self.badgeCircleLayer.fillColor = [[UIColor clearColor] CGColor];
    [self.badgeView.layer addSublayer:self.badgeCircleLayer];
    
    self.badgeNumberLabel = [UILabel newAutoLayoutView];
    self.badgeNumberLabel.font = [UIFont fontWithName:@"OpenSans" size:10];
    self.badgeNumberLabel.textColor = [UIColor colorWithRed:133.0f/255.0f green:161.0f/255.0f blue:165.0f/255.0f alpha:1];
    [self.badgeView addSubview:self.badgeNumberLabel];
    
    [self.badgeNumberLabel autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [self.badgeNumberLabel autoAlignAxisToSuperviewAxis:ALAxisVertical];
    
    [self.contentView addSubview:self.badgeView];
    
    [self.badgeView autoSetDimension:ALDimensionHeight toSize:kXYLeftMenuTableViewCellBadgeViewHeight];
    [self.badgeView autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.iconImageView];
    [self.badgeView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:23];
}

- (void)setupBottomLine
{
    UIView *bottomLine = [UIView newAutoLayoutView];
    bottomLine.backgroundColor = [UIColor colorWithRed:38.0f/255.0f green:44.0f/255.0f blue:48.0f/255.0f alpha:1];
    [self.contentView addSubview:bottomLine];
    
    [bottomLine autoSetDimension:ALDimensionHeight toSize:1];
    [bottomLine autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
    [bottomLine autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
    [bottomLine autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0];
}

#pragma mark -

- (void)setupCellWithImageURL:(NSURL *)imageURL
               titleLabelText:(NSString *)titleLabelText
                  badgeNumber:(NSInteger)badgeNumber
             isFirstInTheList:(BOOL)isFirstInTheList
{
    // todo: download image
    self.iconImageView.image = nil;
    
    __weak __typeof(self) weakSelf = self;
    [self.iconImageView setImageWithURLRequest:[NSURLRequest requestWithURL:imageURL] placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        
        weakSelf.iconImageView.image = image;
        
        weakSelf.activeImage = image;
        weakSelf.inactiveImage = image;
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        
    }];
    
    [self setupCellWithTitleLabelText:titleLabelText
                          badgeNumber:badgeNumber
                     isFirstInTheList:isFirstInTheList];
}

- (void)setupCellWithUnselectedImage:(UIImage *)unselectedImage
                       selectedImage:(UIImage *)selectedImage
                      titleLabelText:(NSString *)titleLabelText
                         badgeNumber:(NSInteger)badgeNumber
                    isFirstInTheList:(BOOL)isFirstInTheList
{
    self.activeImage = selectedImage;
    self.inactiveImage = unselectedImage;
    
    self.iconImageView.image = self.inactiveImage;
    
    [self setupCellWithTitleLabelText:titleLabelText
                          badgeNumber:badgeNumber
                     isFirstInTheList:isFirstInTheList];
}

- (void)setupCellWithTitleLabelText:(NSString *)titleLabelText
                        badgeNumber:(NSInteger)badgeNumber
                   isFirstInTheList:(BOOL)isFirstInTheList
{
    self.isFirstInTheList = isFirstInTheList;
    
    self.titleLabel.text = titleLabelText;
    
    self.badgeNumber = badgeNumber;
    NSString *badgeNumberString;
    if (badgeNumber > 99)
        badgeNumberString = @"99+";
    else
        badgeNumberString = [NSString stringWithFormat:@"%ld", (long)badgeNumber];
    self.badgeNumberLabel.text = badgeNumberString;
    
    [self setNeedsUpdateConstraints];
}
@end

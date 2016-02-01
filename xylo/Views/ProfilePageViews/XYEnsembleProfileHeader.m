//
//  XYEnsembleProfileHeader.m
//  xylo
//
//  Created by Lukas Kekys on 18/04/14.
//  Copyright (c) 2014 Seriously. All rights reserved.
//

#import "XYEnsembleProfileHeader.h"
#import "XYEnsemble+EnsembleFunctions.h"
#import "XYUser+UserFunctions.h"

#define kHeaderWithoutJoinButtonHeight 170
#define kHeaderWithJoinButtonHeight 210

@interface XYEnsembleProfileHeader ()

@property (nonatomic, weak) IBOutlet UIButton *aboutButton;
@property (nonatomic, weak) IBOutlet UIButton *membersButton;
@property (nonatomic, weak) IBOutlet UIButton *joinButton;

- (IBAction)buttonSelected:(UIButton *)sender;
- (IBAction)joinSelected:(id)sender;

@end

@implementation XYEnsembleProfileHeader

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setup];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setup];
}

- (void)setup
{
    self.aboutButton.titleLabel.font = self.membersButton.titleLabel.font = [UIFont fontWithName:@"OpenSans" size:15.0];
    self.joinButton.titleLabel.font = [UIFont fontWithName:@"OpenSans" size:12.0];
    self.joinButton.layer.cornerRadius = 2.0f;
    self.joinButton.layer.masksToBounds = YES;
    self.joinButton.hidden = YES;
    CGRect frame = self.frame;
    frame.size.height = kHeaderWithoutJoinButtonHeight;
    
    self.frame = frame;
    
    NSString *aboutString = @"About";
    NSString *membersString = @"Members";
    [self.aboutButton setTitle:aboutString forState:UIControlStateNormal];
    [self.membersButton setTitle:membersString forState:UIControlStateNormal];
    [self buttonSelected:self.aboutButton];
}

- (void)setupHeaderWithEnsemble:(XYEnsemble *)ensemble
{
    NSString *joinString = (ensemble.name) ? [NSString stringWithFormat:@"Join %@",ensemble.name] : @"Join";
    [self.joinButton setTitle:joinString forState:UIControlStateNormal];
    
    if (![XYUser masterUserBelongsToEnsemble:ensemble]) {
        self.joinButton.hidden = NO;
        CGRect frame = self.frame;
        frame.size.height = kHeaderWithJoinButtonHeight;
        self.frame = frame;
    }
    else {
        self.joinButton.hidden = YES;
        CGRect frame = self.frame;
        frame.size.height = kHeaderWithoutJoinButtonHeight;
        self.frame = frame;
    }
}

- (IBAction)buttonSelected:(UIButton *)sender
{
    if ([sender isEqual:self.membersButton]) {
        self.aboutButton.selected = NO;
        self.aboutButton.backgroundColor = [UIColor colorWithRed:211.0f/255.0f green:220.0f/255.0f blue:224.0f/255.0f alpha:1.0f];
    }
    else {
        self.membersButton.selected = NO;
        self.membersButton.backgroundColor = [UIColor colorWithRed:211.0f/255.0f green:220.0f/255.0f blue:224.0f/255.0f alpha:1.0f];
    }
    
    sender.selected = YES;
    sender.backgroundColor = [UIColor whiteColor];
    
    [self.delegate ensembleProfileHeader:self buttonSelected:sender];
}

- (IBAction)joinSelected:(id)sender
{
    [self.delegate ensembleProfileHeader:self joinSelected:sender];
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

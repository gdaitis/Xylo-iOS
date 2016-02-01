//
//  XYTaskHeaderView.m
//  xylo
//
//  Created by Lukas Kekys on 29/08/14.
//  Copyright (c) 2014 Seriously. All rights reserved.
//

#import "XYTaskHeaderView.h"

@implementation XYTaskHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self.mainButton addTarget:self action:@selector(mainButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)mainButtonPressed:(UIButton *)sender
{
    NSLog(@"mainButtonPressed");
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

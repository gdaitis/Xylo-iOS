//
//  XYPendingContactCell.h
//  xylo
//
//  Created by Lukas Kekys on 15/04/14.
//  Copyright (c) 2014 Seriously. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XYPendingContactCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIButton *messageButton;
@property (nonatomic, weak) IBOutlet UIButton *acceptButton;
@property (nonatomic, weak) IBOutlet UIButton *declineButton;

@end

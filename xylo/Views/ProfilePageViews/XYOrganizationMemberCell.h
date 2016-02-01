//
//  XYOrganizationMemberCell.h
//  xylo
//
//  Created by Lukas Kekys on 15/04/14.
//  Copyright (c) 2014 Seriously. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XYUser;

@interface XYOrganizationMemberCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIButton *messageButton;

- (void)setupCellWithUser:(XYUser *)user;

@end

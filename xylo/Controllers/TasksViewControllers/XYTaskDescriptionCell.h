//
//  XYTaskDescriptionCell.h
//  xylo
//
//  Created by Lukas Kekys on 03/09/14.
//  Copyright (c) 2014 Seriously. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYTasksButton.h"
@interface XYTaskDescriptionCell : UITableViewCell

@property (weak, nonatomic) IBOutlet XYTasksButton *checkboxButton;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@property (assign, nonatomic) BOOL completed;

@end

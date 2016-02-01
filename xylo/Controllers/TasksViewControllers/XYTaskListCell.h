//
//  XYTasksTableViewCell.h
//  xylo
//
//  Created by Lukas Kekys on 26/08/14.
//  Copyright (c) 2014 Seriously. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XYTasksButton;

@interface XYTaskListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet XYTasksButton *checkboxButton;
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UIImageView *recuringImageView;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *dayLabel;
@property (weak, nonatomic) IBOutlet XYTasksButton *favoriteButton;

@property (assign, nonatomic) BOOL marked;
@property (assign, nonatomic) BOOL completed;
@property (assign, nonatomic) BOOL recuring;
@end

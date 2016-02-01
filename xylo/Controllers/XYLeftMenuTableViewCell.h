//
//  XYLeftMenuTableViewCell.h
//  xylo
//
//  Created by lite on 08/05/14.
//  Copyright (c) 2014 Seriously. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XYLeftMenuTableViewCell : UITableViewCell

- (void)setupCellWithImageURL:(NSURL *)imageURL
               titleLabelText:(NSString *)titleLabelText
                  badgeNumber:(NSInteger)badgeNumber
             isFirstInTheList:(BOOL)isFirstInTheList;
- (void)setupCellWithUnselectedImage:(UIImage *)unselectedImage
                       selectedImage:(UIImage *)selectedImage
                      titleLabelText:(NSString *)titleLabelText
                         badgeNumber:(NSInteger)badgeNumber
                    isFirstInTheList:(BOOL)isFirstInTheList;

@end

//
//  XYOrganizationContactInfoCell.h
//  xylo
//
//  Created by Lukas Kekys on 09/04/14.
//  Copyright (c) 2014 Seriously. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XYOrganization,XYEnsemble;

@interface XYOrganizationContactInfoCell : UITableViewCell

- (void)populateCellWithOrganization:(XYOrganization *)organization forIndexPathRow:(NSInteger)row;
- (void)populateCellWithEnsemble:(XYEnsemble *)ensemble forIndexPathRow:(NSInteger)row;

@end

//
//  XYOrganizationEnsembleCell.h
//  xylo
//
//  Created by Lukas Kekys on 09/04/14.
//  Copyright (c) 2014 Seriously. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XYEnsemble;

@interface XYOrganizationEnsembleCell : UITableViewCell

- (void)populateCellWithEnsembleData:(XYEnsemble *)ensemble;

@end

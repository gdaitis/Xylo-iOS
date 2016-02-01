//
//  XYEnsembleProfileHeader.h
//  xylo
//
//  Created by Lukas Kekys on 18/04/14.
//  Copyright (c) 2014 Seriously. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XYEnsembleProfileHeader,XYEnsemble;

@protocol XYEnsembleProfileHeaderDelegate

@optional
- (void)ensembleProfileHeader:(XYEnsembleProfileHeader *)ensembleProfileHeader buttonSelected:(UIButton *)button;
- (void)ensembleProfileHeader:(XYEnsembleProfileHeader *)ensembleProfileHeader joinSelected:(UIButton *)button;

@end

@interface XYEnsembleProfileHeader : UIView

@property (nonatomic, weak) id <XYEnsembleProfileHeaderDelegate> delegate;

- (void)setupHeaderWithEnsemble:(XYEnsemble *)ensemble;

@end

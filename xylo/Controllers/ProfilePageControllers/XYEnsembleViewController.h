//
//  XYEnsembleViewController.h
//  xylo
//
//  Created by Lukas Kekys on 16/04/14.
//  Copyright (c) 2014 Seriously. All rights reserved.
//

#import "XYBaseProfilePageController.h"

@class XYEnsemble;

typedef enum {
    ENSEMBLE_TYPE_ABOUT = 0,
    ENSEMBLE_TYPE_MEMBERS = 1
}EnsembleViewType;

@interface XYEnsembleViewController : XYBaseProfilePageController

@property (nonatomic, strong) XYEnsemble *ensemble;
@property (nonatomic, assign) EnsembleViewType ensembleViewType;

@end

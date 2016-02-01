//
//  XYEnsembleSelectionButton.m
//  xylo
//
//  Created by Lukas Kekys on 20/03/14.
//  Copyright (c) 2014 Seriously. All rights reserved.
//

#import "XYEnsembleSelectionButton.h"
#import "XYEnsemble.h"

@interface XYEnsembleSelectionButton ()

@end


@implementation XYEnsembleSelectionButton

- (void)setEnsemble:(XYEnsemble *)ensemble
{
    _ensemble = ensemble;
    self.mainTitleLabel.text = ensemble.name;
}


@end

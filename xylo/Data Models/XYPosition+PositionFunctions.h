//
//  XYPosition+PositionFunctions.h
//  xylo
//
//  Created by Lukas Kekys on 13/05/14.
//  Copyright (c) 2014 Seriously. All rights reserved.
//

#import "XYPosition.h"

@class XYEnsemble;

@interface XYPosition (PositionFunctions)

+ (void)importPositions:(id)data forEnsemble:(XYEnsemble *)ensemble;

@end

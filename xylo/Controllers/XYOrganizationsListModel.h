//
//  XYOrganizationsListModel.h
//  xylo
//
//  Created by Lukas Kekys on 02/07/14.
//  Copyright (c) 2014 Seriously. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const XYLeftMenuViewControllerListUpdateDate;

@class XYOrganizationsListModel;

@protocol XYOrganizationsListModelDelegate <NSObject>

@optional
-(void)organizationListChanged:(XYOrganizationsListModel *)listModel;

@end

@interface XYOrganizationsListModel : NSObject

@property (nonatomic, weak) id <XYOrganizationsListModelDelegate> delegate;
@property (nonatomic, strong) NSArray *organizations;

- (void)loadOrganizations;
- (void)updateListModelIfNeeded;

@end

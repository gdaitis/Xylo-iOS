//
//  XYLeftMenuViewController.m
//  xylo
//
//  Created by lite on 09/04/14.
//  Copyright (c) 2014 Seriously. All rights reserved.
//

#import "XYLeftMenuViewController.h"
#import "XYOrganizationViewController.h"
#import "XYEnsembleViewController.h"
#import "XYLoggedInNavigationViewController.h"
#import "UIViewController+MMDrawerController.h"
#import "XYRootViewController.h"
#import "XYLeftMenuTableViewCell.h"
#import "XYLoginService.h"
#import "XYOrganizationsListModel.h"
#import "XYOrganization.h"
#import "XYUser+UserFunctions.h"
#import "XYTaskListViewController.h"

#define kDefaultListSize 9

@interface XYLeftMenuViewController () <UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate,XYOrganizationsListModelDelegate>

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSLayoutConstraint *contentViewWidthConstraint;
@property (nonatomic, assign) NSInteger selectedRow;
@property (nonatomic, strong) XYOrganizationsListModel *listModel;

@end

@implementation XYLeftMenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIColor *bgColor = [UIColor colorWithRed:49.0f/255.0f green:56.0f/255.0f blue:60.0f/255.0f alpha:1];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateLeftMenu)
                                                 name:kUpdateLeftMenuNotification
                                               object:nil];
    
    self.view.backgroundColor = bgColor;
    
    [self.mm_drawerController setMaximumLeftDrawerWidth:kXYRootViewControllerWidthOfLeftMenuNormal];
    
    [self setupContentViewWithBgColor:bgColor];
    [self setupXyloLogo];
    [self setupSearchBar];
    [self setupTableView];
    [self setupOrganizationsListModel];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

}

- (void)updateViewConstraints
{
    [super updateViewConstraints];
}

- (void)updateLeftMenu
{
    [self.tableView reloadData];
}

#pragma mark - Setup views

- (void)setupContentViewWithBgColor:(UIColor *)bgColor
{
    self.contentView = [UIView newAutoLayoutView];
    [self.view addSubview:self.contentView];
    
    self.contentViewWidthConstraint = [self.contentView autoSetDimension:ALDimensionWidth toSize:kXYRootViewControllerWidthOfLeftMenuNormal];
    [self.contentView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
    [self.contentView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0];
    [self.contentView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0];
}

- (void)setupXyloLogo
{
    UIImage *xyloLogoImage = [UIImage imageNamed:@"xyloLogoMenu"];
    UIImageView *xyloLogoImageView = [UIImageView newAutoLayoutView];
    xyloLogoImageView.image = xyloLogoImage;
    [self.contentView addSubview:xyloLogoImageView];
    
    [xyloLogoImageView autoSetDimensionsToSize:CGSizeMake(xyloLogoImage.size.width, xyloLogoImage.size.height)];
    [xyloLogoImageView autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [xyloLogoImageView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:18];
}

- (void)setupSearchBar
{
    self.searchBar = [UISearchBar newAutoLayoutView];
    self.searchBar.delegate = self;
    
    UIColor *tintColor = [UIColor colorWithRed:49.0f/255.0f green:56.0f/255.0f blue:60.0f/255.0f alpha:1];
    [self.searchBar setSearchFieldBackgroundImage:[UIImage imageNamed:@"searchBarInactiveBg"] forState:UIControlStateNormal];
    [self.searchBar setBarTintColor:tintColor];
    self.searchBar.translucent = NO;
    [self.searchBar setShowsCancelButton:NO animated:NO];
    self.searchBar.layer.borderWidth = 1;
    self.searchBar.layer.borderColor = tintColor.CGColor;
    UIFont *font = [UIFont fontWithName:@"OpenSans" size:15];
    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setFont:font];
    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setLeftView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"searchBarGlass"]]];
    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setTextColor:[UIColor colorWithRed:42.0f/255.0f green:48.0f/255.0f blue:52.0f/255.0f alpha:1]];
    NSString *searchText = @"Search";
    [self.searchBar setPlaceholder:searchText];
    
    [[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor colorWithRed:133.0f/255.0f
                                                                                                                                                   green:161.0f/255.0f
                                                                                                                                                    blue:165.0f/255.0f
                                                                                                                                                   alpha:1],
                                                                                                   NSFontAttributeName: font}
                                                                                        forState:UIControlStateNormal];
    
    [self.contentView addSubview:self.searchBar];
    
    [self.searchBar autoSetDimension:ALDimensionHeight toSize:49];
    [self.searchBar autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
    [self.searchBar autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
    [self.searchBar autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:[UIApplication sharedApplication].statusBarFrame.size.height+2];
    
    UIColor *lineColor = [UIColor colorWithRed:38.0f/255.0f green:44.0f/255.0f blue:48.0f/255.0f alpha:1];
    
    UIView *topLine = [UIView newAutoLayoutView];
    topLine.backgroundColor = lineColor;
    [self.contentView addSubview:topLine];
    
    [topLine autoSetDimension:ALDimensionHeight toSize:1];
    [topLine autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
    [topLine autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
    [topLine autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.searchBar withOffset:0];
    
    UIView *bottomLine = [UIView newAutoLayoutView];
    bottomLine.backgroundColor = lineColor;
    [self.contentView addSubview:bottomLine];
    
    [bottomLine autoSetDimension:ALDimensionHeight toSize:1];
    [bottomLine autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
    [bottomLine autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
    [bottomLine autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.searchBar withOffset:0];
}

- (void)setupTableView
{
    UITableView *tableView = [UITableView newAutoLayoutView];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = [UIColor clearColor];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.separatorColor = [UIColor colorWithRed:38.0f/255.0f green:44.0f/255.0f blue:48.0f/255.0f alpha:1];
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:tableView];
    
    [tableView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.searchBar];
    [tableView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
    [tableView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0];
    [tableView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
    
    self.tableView = tableView;
}

#pragma mark - UITableView delegate & dataSource methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return kDefaultListSize + [self.listModel.organizations count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"LeftMenuControllerCellId";
    XYLeftMenuTableViewCell *cell = (XYLeftMenuTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[XYLeftMenuTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    BOOL isFirst = NO;
    if (indexPath.row == 0)
        isFirst = YES;
    
    NSInteger badgeNumber = 9;
    
    NSString *title;
    UIImage *inactiveImage;
    UIImage *activeImage;
    NSURL *imageUrl;
    
    if (indexPath.row == 0) {
        title = [[XYUser masterUser] fullName];
        imageUrl = [NSURL URLWithString:[[XYUser masterUser] logoImageUrl]];
    } else if (indexPath.row == 1) {
        NSString *calendarString = @"Calendar";
        title = calendarString;
        inactiveImage = [UIImage imageNamed:@"leftMenuCalendarInactive"];
        activeImage = [UIImage imageNamed:@"leftMenuCalendarActive"];
    } else if (indexPath.row == 2) {
        NSString *tasksString = @"Tasks";
        title = tasksString;
        inactiveImage = [UIImage imageNamed:@"leftMenuTasksInactive"];
        activeImage = [UIImage imageNamed:@"leftMenuTasksActive"];
    } else if (indexPath.row == 3) {
        NSString *contactsString = @"Contacts";
        title = contactsString;
        inactiveImage = [UIImage imageNamed:@"leftMenuContactsInactive"];
        activeImage = [UIImage imageNamed:@"leftMenuContactsActive"];
    } else if (indexPath.row == 4) {
        NSString *inventoryString = @"Inventory";
        title = inventoryString;
        inactiveImage = [UIImage imageNamed:@"leftMenuInventoryInactive"];
        activeImage = [UIImage imageNamed:@"leftMenuInventoryActive"];
    } else if (indexPath.row == 5) {
        NSString *libraryString = @"Library";
        title = libraryString;
        inactiveImage = [UIImage imageNamed:@"leftMenuLibraryInactive"];
        activeImage = [UIImage imageNamed:@"leftMenuLibraryActive"];
    } else if (indexPath.row == 6) {
        NSString *mediaString = @"Media";
        title = mediaString;
        inactiveImage = [UIImage imageNamed:@"leftMenuMediaInactive"];
        activeImage = [UIImage imageNamed:@"leftMenuMediaActive"];
    } else if (indexPath.row == 7) {
        NSString *financesString = @"Finances";
        title = financesString;
        inactiveImage = [UIImage imageNamed:@"leftMenuFinancesInactive"];
        activeImage = [UIImage imageNamed:@"leftMenuFinancesActive"];
    } else if (indexPath.row == kDefaultListSize + [self.listModel.organizations count]-1) {
        imageUrl = nil;
        title = @"Logout";
    }
    else {
        XYOrganization *organization = [self.listModel.organizations objectAtIndex:indexPath.row+1-kDefaultListSize];
        imageUrl = [NSURL URLWithString:organization.logoImageUrl];
        title = organization.name;
    }
    
    if (indexPath.row == 0 || indexPath.row > 7)
        [cell setupCellWithImageURL:imageUrl
                     titleLabelText:title
                        badgeNumber:badgeNumber
                   isFirstInTheList:isFirst];
    else
        [cell setupCellWithUnselectedImage:inactiveImage
                             selectedImage:activeImage
                            titleLabelText:title
                               badgeNumber:badgeNumber
                          isFirstInTheList:isFirst];
    
    
    if (indexPath.row == self.selectedRow && self.selectedRow != -1)
        [cell setSelected:YES animated:NO];
    
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedRow = indexPath.row;
    UIViewController *viewController = nil;
    
    if (indexPath.row == 0) {

    } else if (indexPath.row == 1) {

    } else if (indexPath.row == 2) {
        
        XYTaskListViewController *tasksController = [[XYTaskListViewController alloc] initWithNibName:@"XYTaskListViewController" bundle:nil];
        viewController = tasksController;

    } else if (indexPath.row == 3) {

    } else if (indexPath.row == 4) {

    } else if (indexPath.row == 5) {

    } else if (indexPath.row == 6) {

    } else if (indexPath.row == 7) {

    } else if (indexPath.row == kDefaultListSize + [self.listModel.organizations count]-1) {
        //logout
        [XYLoginService logout];
        self.selectedRow = -1;
    }
    else {
        //organizations
        XYOrganizationViewController *organizationViewController = [[XYOrganizationViewController alloc] init];
        organizationViewController.organization = [self.listModel.organizations objectAtIndex:indexPath.row+1-kDefaultListSize];
        viewController = organizationViewController;
    }
    
    if (viewController) {
        XYLoggedInNavigationViewController *navigationController = [[XYLoggedInNavigationViewController alloc] initWithRootViewController:viewController];
        [self.mm_drawerController setCenterViewController:navigationController
                                       withCloseAnimation:YES
                                               completion:nil];
    }
}

#pragma mark - UISearchBar delegate methods

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    [self.searchBar setSearchFieldBackgroundImage:[UIImage imageNamed:@"searchBarActiveBg"] forState:UIControlStateNormal];
    [self.searchBar setShowsCancelButton:YES animated:YES];
    
    [self.mm_drawerController setShowsShadow:NO];
    
    self.contentViewWidthConstraint.constant = [[UIScreen mainScreen] bounds].size.width;
    [UIView animateWithDuration:0.1
                     animations:^{
                         [self.view layoutIfNeeded];
                     } completion:^(BOOL finished) {
                         [self.mm_drawerController setMaximumLeftDrawerWidth:[[UIScreen mainScreen] bounds].size.width
                                                                    animated:YES
                                                                  completion:nil];
                     }];
    
    
    
    return YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self.searchBar setSearchFieldBackgroundImage:[UIImage imageNamed:@"searchBarInactiveBg"] forState:UIControlStateNormal];
    [self.searchBar setShowsCancelButton:NO animated:YES];
    [self.searchBar resignFirstResponder];
    
    [self.mm_drawerController setShowsShadow:YES];
    
    self.contentViewWidthConstraint.constant = kXYRootViewControllerWidthOfLeftMenuNormal;
    
    __weak UIView *view = self.view;
    
    [self.mm_drawerController setMaximumLeftDrawerWidth:kXYRootViewControllerWidthOfLeftMenuNormal
                                               animated:YES
                                             completion:^(BOOL finished) {
                                                 [UIView animateWithDuration:0.1
                                                                  animations:^{
                                                                      [view layoutIfNeeded];
                                                                  } completion:^(BOOL finished) {
                                                                      
                                                                  }];
                                             }];
}

#pragma mark - Organization list model/updates

- (void)updateOrganizationlistModel
{
    if (self.listModel) {
        [self.listModel updateListModelIfNeeded];
    }
}

- (void)setupOrganizationsListModel
{
    XYOrganizationsListModel *organizationListModel = [[XYOrganizationsListModel alloc] init];
    organizationListModel.delegate = self;
    self.listModel = organizationListModel;
    [self.listModel loadOrganizations];
}


#pragma mark - ListModel delegate

-(void)organizationListChanged:(XYOrganizationsListModel *)listModel
{
    [self.tableView reloadData];
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:kUpdateLeftMenuNotification
                                                  object:nil];
}

@end

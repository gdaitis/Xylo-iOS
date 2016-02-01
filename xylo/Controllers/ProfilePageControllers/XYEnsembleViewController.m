//
//  XYEnsembleViewController.m
//  xylo
//
//  Created by Lukas Kekys on 16/04/14.
//  Copyright (c) 2014 Seriously. All rights reserved.
//

#import "XYEnsembleViewController.h"
#import "XYOrganizationProfileHeader.h"
#import "UIView+NibLoading.h"
#import "XYOrganizationContactInfoCell.h"
#import "XYOrganizationEnsembleCell.h"
#import "XYOrganizationSocialCell.h"
#import "XYOrganizationMemberCell.h"
#import "XYPendingContactCell.h"
#import "XYEnsembleProfileHeader.h"
#import "XYEnsemble+EnsembleFunctions.h"
#import "XYEnsembleService.h"

@interface XYEnsembleViewController () <UITableViewDataSource,UITableViewDelegate,XYEnsembleProfileHeaderDelegate>

@property (nonatomic, strong) XYEnsembleProfileHeader *headerView;
@property (nonatomic, strong) NSArray *contactInfoArray;
@property (nonatomic, strong) NSArray *socialDataArray;

@end

@implementation XYEnsembleViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = self.ensemble.name;
    [self enableCustomNavigationBar];
    self.navigationItem.hidesBackButton = YES;
    
    if (!self.headerView) {
        XYEnsembleProfileHeader *header = (XYEnsembleProfileHeader *)[XYEnsembleProfileHeader loadInstanceFromNib];
        self.headerView = header;
    }
    self.headerView.delegate = self;
    [self.headerView setupHeaderWithEnsemble:self.ensemble];
    self.tableView.tableHeaderView = self.headerView;
    
    [self loadViewData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [XYEnsembleService getEnsembleInfoWithId:self.ensemble.ensembleID successBlock:^{
        [self.headerView setupHeaderWithEnsemble:self.ensemble];
        [self.tableView reloadData];
    } failureBlock:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadViewData
{
    //    NSDictionary *dir = [[NSDictionary alloc] initWithObjectsAndKeys:@"Director",@"title",@"David Gibbs",@"subtitle", nil];
    //    NSDictionary *web = [[NSDictionary alloc] initWithObjectsAndKeys:@"Website",@"title",@"www.bluedevils.org",@"subtitle", nil];
    //    NSDictionary *ph = [[NSDictionary alloc] initWithObjectsAndKeys:@"Phone",@"title",@"+123456789",@"subtitle", nil];
    //    NSDictionary *add = [[NSDictionary alloc] initWithObjectsAndKeys:@"Address",@"title",@"4065 Nelson Ave Concord, CA 94520",@"subtitle", nil];
    //    self.contactInfoArray = [[NSMutableArray alloc] initWithObjects:dir,web,ph,add, nil];
    
//    NSDictionary *soc1 = [[NSDictionary alloc] initWithObjectsAndKeys:@"Today 09:40",@"date",@"via Twitter",@"socialNetwork",@"Some Text",@"socialText", nil];
//    NSDictionary *soc2 = [[NSDictionary alloc] initWithObjectsAndKeys:@"Today 08:32",@"date",@"via Twitter",@"socialNetwork",@"Other random text",@"socialText", nil];
//    self.socialDataArray = [[NSMutableArray alloc] initWithObjects:soc1,soc2, nil];
}

#pragma mark - TableView data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.ensembleViewType == ENSEMBLE_TYPE_ABOUT) {
        return 4;
    }
    else {
        return [self.ensemble.users count];
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.ensembleViewType == ENSEMBLE_TYPE_ABOUT) {

            XYOrganizationContactInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XYOrganizationContactInfoCellID"];
            if (!cell) {
                cell = (XYOrganizationContactInfoCell *)[XYOrganizationContactInfoCell loadInstanceFromNib];
            }
            [cell populateCellWithEnsemble:self.ensemble forIndexPathRow:indexPath.row];
            return cell;
//        }
//        else {
//            XYOrganizationSocialCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XYOrganizationSocialCellID"];
//            if (!cell) {
//                cell = (XYOrganizationSocialCell *)[XYOrganizationSocialCell loadInstanceFromNib];
//            }
//            [cell populateCellWithSocialData:[self.socialDataArray objectAtIndex:indexPath.row]];
//            return cell;
//        }
    }
    else {
        //        if (indexPath.section == 0) {
        //            XYPendingContactCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XYPendingContactCellID"];
        //            if (!cell) {
        //                cell = (XYPendingContactCell *)[XYPendingContactCell loadInstanceFromNib];
        //            }
        //            //            [cell populateCellWithContactsData:[self.contactInfoArray objectAtIndex:indexPath.row]];
        //            return cell;
        //        }
        //        else {
        
        XYOrganizationMemberCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XYOrganizationMemberCellID"];
        if (!cell) {
            cell = (XYOrganizationMemberCell *)[XYOrganizationMemberCell loadInstanceFromNib];
        }
        NSArray *sortedArray = [self.ensemble usersSortedByName];
        [cell setupCellWithUser:[sortedArray objectAtIndex:indexPath.row]];
        
        return cell;
        //        }
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //for now, will be different if there will be pending contacts or not
//    int result = (self.ensembleViewType == ENSEMBLE_TYPE_ABOUT) ? 2: 1;
    return 1;
}

#pragma mark - TableView delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.ensembleViewType == ENSEMBLE_TYPE_ABOUT) {
//        if (indexPath.section == 0)
            return 37;
//        else
//            return 80;
    }
    else {
        return 50;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 30)];
    view.backgroundColor = [UIColor colorWithRed:239.0/255.0 green:243.0/255.0 blue:245.0/255.0 alpha:1.0];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 300, 20)];
    label.font = [UIFont fontWithName:@"OpenSans-Semibold" size:11.0];
    label.textColor = [UIColor colorWithRed:167.0/255.0 green:191.0/255.0 blue:203.0/255.0 alpha:1.0];
    
    
    if (self.ensembleViewType == ENSEMBLE_TYPE_ABOUT) {
//        if (section == 0) {
            label.text = @"Contact information";
//        }
//        else {
//            label.text = @"Social media";
//        }
    }
    else {
        label.text = @"Members";
    }
    
    
    [view addSubview:label];
    
    return view;
}

#pragma mark - XYEnsembleProfileHeader delegate

- (void)ensembleProfileHeader:(XYEnsembleProfileHeader *)ensembleProfileHeader buttonSelected:(UIButton *)button
{
    if (button.tag == 1) {
        //about button selected
        self.ensembleViewType = ENSEMBLE_TYPE_ABOUT;
    }
    else {
        //member button selected
        self.ensembleViewType = ENSEMBLE_TYPE_MEMBERS;
    }
    [self.tableView reloadData];
}

- (void)ensembleProfileHeader:(XYEnsembleProfileHeader *)ensembleProfileHeader joinSelected:(UIButton *)button
{
#warning finish join button action
    
}

@end

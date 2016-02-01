//
//  XYOrganizationViewController.m
//  xylo
//
//  Created by Lukas Kekys on 08/04/14.
//  Copyright (c) 2014 Seriously. All rights reserved.
//

#import "XYOrganizationViewController.h"
#import "XYEnsembleViewController.h"

#import "XYOrganizationProfileHeader.h"
#import "UIView+NibLoading.h"
#import "XYOrganizationContactInfoCell.h"
#import "XYOrganizationEnsembleCell.h"
#import "XYOrganizationSocialCell.h"
#import "XYOrganization+OrganizationFunctions.h"

#import "XYOrganizationService.h"
#import "XYEnsembleService.h"

@interface XYOrganizationViewController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) XYOrganizationProfileHeader *headerView;
@property (nonatomic, strong) NSArray *contactInfoArray;
@property (nonatomic, strong) NSArray *ensemblesArray;
@property (nonatomic, strong) NSArray *socialDataArray;

@end

@implementation XYOrganizationViewController

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
    
    self.title = self.organization.name;
    [self enableCustomNavigationBar];
    
    if (!self.headerView) {
        XYOrganizationProfileHeader *header = (XYOrganizationProfileHeader *)[XYOrganizationProfileHeader loadInstanceFromNib];
        self.headerView = header;
    }
    [self.headerView setupHeaderWithOrganization:self.organization];
    self.tableView.tableHeaderView = self.headerView;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 1)];
    self.tableView.tableFooterView = view;
    
    
    [self loadViewData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self updateOrganization];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateEnsembles
{
    [XYOrganizationService getEnsemblesForOrganizationWithStringId:[self.organization.organizationID stringValue] successBlock:^{
        
        [self.tableView reloadData];
        
    } failureBlock:^{
        
    }];
}

- (void)updateOrganization
{
    [XYOrganizationService getOrganizationInfoWithId:self.organization.organizationID successBlock:^{
        
        NSIndexSet *set = [[NSIndexSet alloc] initWithIndex:0];
        [self.tableView reloadSections:set withRowAnimation:UITableViewRowAnimationAutomatic];
        [self updateEnsembles];
        
    } failureBlock:^(XYOrganizationServiceCodeCheckError codeCheckError) {
        
    }];
}

- (void)loadViewData
{
#warning only testing data!
    //    NSDictionary *dir = [[NSDictionary alloc] initWithObjectsAndKeys:@"Director",@"title",@"David Gibbs",@"subtitle", nil];
    //    NSDictionary *web = [[NSDictionary alloc] initWithObjectsAndKeys:@"Website",@"title",@"www.bluedevils.org",@"subtitle", nil];
    //    NSDictionary *ph = [[NSDictionary alloc] initWithObjectsAndKeys:@"Phone",@"title",@"+123456789",@"subtitle", nil];
    //    NSDictionary *add = [[NSDictionary alloc] initWithObjectsAndKeys:@"Address",@"title",@"4065 Nelson Ave Concord, CA 94520",@"subtitle", nil];
    //    self.contactInfoArray = [[NSMutableArray alloc] initWithObjects:dir,web,ph,add, nil];
    
//    NSDictionary *soc1 = [[NSDictionary alloc] initWithObjectsAndKeys:@"Today 09:40",@"date",@"via Twitter",@"socialNetwork",@"Some Testing Text",@"socialText", nil];
//    NSDictionary *soc2 = [[NSDictionary alloc] initWithObjectsAndKeys:@"Today 08:32",@"date",@"via Twitter",@"socialNetwork",@"Other random testing text",@"socialText", nil];
//    self.socialDataArray = [[NSMutableArray alloc] initWithObjects:soc1,soc2, nil];
}

#pragma mark - TableView data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        int result = (self.organization.boosters.length == 0) ? 4 : 5;
        return result;
    }
    else
        return [self.organization.ensembles count];
//    else
//        return [self.socialDataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        XYOrganizationContactInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XYOrganizationContactInfoCellID"];
        if (!cell) {
            cell = (XYOrganizationContactInfoCell *)[XYOrganizationContactInfoCell loadInstanceFromNib];
        }
        [cell populateCellWithOrganization:self.organization forIndexPathRow:indexPath.row];
        return cell;
    }
    else {
        
        if ([self.organization.ensembles count] > 0) {
            
            XYOrganizationEnsembleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XYOrganizationEnsembleCellID"];
            if (!cell) {
                cell = (XYOrganizationEnsembleCell *)[XYOrganizationEnsembleCell loadInstanceFromNib];
            }
            NSArray *sortedArray = [self.organization ensemblesSortedByName];
            [cell populateCellWithEnsembleData:[sortedArray objectAtIndex:indexPath.row]];
            return cell;
        }
        else {
            XYOrganizationSocialCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XYOrganizationSocialCellID"];
            if (!cell) {
                cell = (XYOrganizationSocialCell *)[XYOrganizationSocialCell loadInstanceFromNib];
            }
            [cell populateCellWithSocialData:[self.socialDataArray objectAtIndex:indexPath.row]];
            return cell;
        }
    }
//    else {
//        XYOrganizationSocialCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XYOrganizationSocialCellID"];
//        if (!cell) {
//            cell = (XYOrganizationSocialCell *)[XYOrganizationSocialCell loadInstanceFromNib];
//        }
//        [cell populateCellWithSocialData:[self.socialDataArray objectAtIndex:indexPath.row]];
//        return cell;
//    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    int result = 2;
    
    if ([self.organization.ensembles count] == 0) {
        result = 1;
    }
    return result;
}

#pragma mark - TableView delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        //currently do nothing
    }
    else {
        
        if ([self.organization.ensembles count] > 0) {
            [self showEnsembleAtIndex:indexPath.row];
        }
        else {
            //currently do nothing
        }
    }
//    else
//    {
//        //currently do nothing
//    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
        return 37;
    else {
        
        if ([self.organization.ensembles count] > 0) {
            return 48;
        }
        else {
            return 80;
        }
    }
//    else
//        return 80;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 26;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 26)];
    view.backgroundColor = [UIColor colorWithRed:239.0/255.0 green:243.0/255.0 blue:245.0/255.0 alpha:1.0];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 300, 20)];
    label.font = [UIFont fontWithName:@"OpenSans-Semibold" size:11.0];
    label.textColor = [UIColor colorWithRed:167.0/255.0 green:191.0/255.0 blue:203.0/255.0 alpha:1.0];
    
    if (section == 0) {
        label.text = @"Contact information";
    }
    else {
        
//        if ([self.organization.ensembles count] > 0) {
            label.text = @"Ensembles";
//        }
//        else {
//            label.text = @"Social media";
//        }
    }
//    else {
//        label.text = @"Social media";
//    }
    
    [view addSubview:label];
    
    return view;
}

- (void)showEnsembleAtIndex:(NSInteger)index
{
    NSArray *sortedArray = [self.organization ensemblesSortedByName];
    
    XYEnsembleViewController *ensembleViewController = [[XYEnsembleViewController alloc] initWithNibName:@"XYEnsembleViewController" bundle:nil];
    ensembleViewController.ensemble = [sortedArray objectAtIndex:index];
    
    [self.navigationController pushViewController:ensembleViewController animated:YES];
}

@end

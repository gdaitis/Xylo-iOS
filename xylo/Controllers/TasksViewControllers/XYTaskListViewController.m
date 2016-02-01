//
//  XYTasksViewController.m
//  xylo
//
//  Created by Lukas Kekys on 26/08/14.
//  Copyright (c) 2014 Seriously. All rights reserved.
//

#import "XYTaskListViewController.h"
#import "XYTaskListCell.h"
#import "UIView+NibLoading.h"
#import "XYTaskListModel.h"
#import "XYTask.h"
#import "UIImageView+AFNetworking.h"
#import "XYUser+UserFunctions.h"
#import "XYTaskHeaderView.h"
#import "XYUtils.h"
#import "XYTasksButton.h"
#import "XYTaskService.h"
#import "XYTaskViewController.h"

#define kTableSectionHeaderHeight 23
#define kTableCellHeight 58

@interface XYTaskListViewController () <UITableViewDataSource,UITableViewDelegate, XYTaskListModelDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) XYTaskListModel *taskListModel;
@property (nonatomic, strong) XYUser *masterUser;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, weak) XYTaskHeaderView *taskHeaderView;

@end

@implementation XYTaskListViewController

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
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.tintColor = [UIColor grayColor];
    [self.refreshControl addTarget:self action:@selector(manualTableDataReload) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
    
    self.title = @"Tasks";
    [self enableCustomNavigationBar];
    self.masterUser = [XYUser masterUser];
    
    
    XYTaskListModel *taskListModel = [[XYTaskListModel alloc] init];
    self.taskListModel = taskListModel;
    self.taskListModel.delegate = self;
    [self.taskListModel loadTasks];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //setting up header
    if (self.taskHeaderView == nil) {
        XYTaskHeaderView *taskHeaderView = (XYTaskHeaderView *)[XYTaskHeaderView loadInstanceFromNib];
        [taskHeaderView.mainButton addTarget:self action:@selector(headerViewSelected:) forControlEvents:UIControlEventTouchUpInside];
        //        taskHeaderView.translatesAutoresizingMaskIntoConstraints = NO;
        self.taskHeaderView = taskHeaderView;
        self.tableView.tableHeaderView = self.taskHeaderView;
    }
    
    [self.taskListModel updateListModelIfNeeded];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)manualTableDataReload
{
    if (self.taskListModel) {
        [self.taskListModel reloadCompletedTasks]; //removes any still visible tasks which are not needed anymore
                                                   //(when a user marks a task it should still be visible for some time, until reload of a view)
        [self.taskListModel downloadTasks];
    }
}

#pragma mark - UITableView data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger result = 0;
    if (section == 0) {
        if (self.taskListModel.todayTasksArray.count > 0) {
            result = self.taskListModel.todayTasksArray.count;
        }
        else {
            result = self.taskListModel.upcomingTasksArray.count;
        }
    }
    else {
        result = self.taskListModel.upcomingTasksArray.count;
    }
    return result;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *headerTitle = @"Upcoming";
    if (section == 0 && self.taskListModel.todayTasksArray.count  > 0) {
        headerTitle = @"Today";
    }
    return headerTitle;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kTableCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XYTaskListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XYTaskListCellID"];
    if (!cell) {
        cell = (XYTaskListCell *)[XYTaskListCell loadInstanceFromNib];
        [cell.checkboxButton addTarget:self action:@selector(checkboxButtonSelected:) forControlEvents:UIControlEventTouchUpInside];
        [cell.favoriteButton addTarget:self action:@selector(favoriteButtonSelected:) forControlEvents:UIControlEventTouchUpInside];
    }
    cell.checkboxButton.indexPath = indexPath;
    cell.favoriteButton.indexPath = indexPath;
    
    XYTask *task = nil;
    if (indexPath.section == 0 && self.taskListModel.todayTasksArray.count > 0) {
        task = [self.taskListModel.todayTasksArray objectAtIndex:indexPath.row];
    }
    else {
        task = [self.taskListModel.upcomingTasksArray objectAtIndex:indexPath.row];
    }
    
    cell.descriptionLabel.text = task.name ? task.name : task.description;
    NSDictionary *timeDataDictionary = [XYUtils timeLeftFromDate:task.dueDate];
    cell.dayLabel.text = timeDataDictionary[@"resultString"];
    cell.dayLabel.textColor = timeDataDictionary[@"resultColor"];
    
    cell.marked = ([task.isMarked boolValue]) ? YES : NO;
    cell.completed = ([task.isCompleted boolValue]) ? YES : NO;
    cell.recuring = ([task.isRecurring boolValue]) ? YES : NO;
    

    //set user image
    [cell.userImageView cancelImageRequestOperation];
    [cell.userImageView setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.masterUser.logoImageUrl]] placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        [cell.userImageView setImage:image];
    } failure:nil];
    
    return cell;
    
}

#pragma mark - UITableView delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    int result = 0;
    
    if (self.taskListModel.todayTasksArray.count > 0) {
        result++;
    }
    if (self.taskListModel.upcomingTasksArray.count > 0) {
        result ++;
    }
    
    if (result == 0) {
        result++;
    }
    
    return result;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSString *headerString = @"Today";
    
    if (section == 0) {
        if (self.taskListModel.todayTasksArray.count == 0 && self.taskListModel.upcomingTasksArray.count > 0) {
            headerString = @"Upcoming";
        }
    }
    else {
        headerString = @"Upcoming";
    }
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, kTableSectionHeaderHeight)];
    view.backgroundColor = [UIColor colorWithRed:239.0f/255.0f green:243.0f/255.0f blue:245.0f/255.0f alpha:1.0f];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 7, tableView.frame.size.width - 20, 14)];
    titleLabel.font = [UIFont fontWithName:@"OpenSans" size:11];
    titleLabel.textColor = [UIColor colorWithRed:165.0f/255.0f green:182.0f/255.0f blue:191.0f/255.0f alpha:1.0f];
    titleLabel.text = headerString;
    
    [view addSubview:titleLabel];
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return kTableSectionHeaderHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    XYTask *task = (indexPath.section == 0 && self.taskListModel.todayTasksArray.count > 0) ? [self.taskListModel.todayTasksArray objectAtIndex:indexPath.row] : [self.taskListModel.upcomingTasksArray objectAtIndex:indexPath.row];
    
    XYTaskViewController *taskViewController = [[XYTaskViewController alloc] initWithNibName:@"XYTaskViewController" bundle:nil];
    taskViewController.currentTask = task;
    
    [self.navigationController pushViewController:taskViewController animated:YES];
}

#pragma mark - Task list model delegate

- (void)taskListChanged:(XYTaskListModel *)taskListModel
{
    [self.refreshControl endRefreshing];
    [self.tableView reloadData];
}

#pragma mark - IBActions

- (void)headerViewSelected:(UIButton *)sender
{
    
}

- (void)checkboxButtonSelected:(XYTasksButton *)sender
{
    XYTask *task = nil;
    if (sender.indexPath.section == 0 && self.taskListModel.todayTasksArray.count > 0) {
        task = [self.taskListModel.todayTasksArray objectAtIndex:sender.indexPath.row];
    }
    else {
        task = [self.taskListModel.upcomingTasksArray objectAtIndex:sender.indexPath.row];
    }
    
    [self showProgressHudInView:self.view withText:nil];
    
    //mark task as completed
    [XYTaskService markTaskAsCompleted:task successBlock:^(XYTask *resultTask) {
        
        [self.taskListModel addRemoveVisibleTasks:resultTask]; //this deals with tasks that should be still visible after you mark it as done
        [self.taskListModel loadTasks];
        [self hideProgressHudInView:self.view];
    } failureBlock:^{
        //show error
        [self hideProgressHudInView:self.view];
        [self showAlertWithTitle:nil andErrorMessage:@"Something went wrong, try again later"];
    }];
    
}

- (void)favoriteButtonSelected:(XYTasksButton *)sender
{
    XYTask *task = nil;
    if (sender.indexPath.section == 0 && self.taskListModel.todayTasksArray.count > 0) {
        task = [self.taskListModel.todayTasksArray objectAtIndex:sender.indexPath.row];
    }
    else {
        task = [self.taskListModel.upcomingTasksArray objectAtIndex:sender.indexPath.row];
    }
    
    [self showProgressHudInView:self.view withText:nil];
    
    NSLog(@"task.isMarked = %@",task.isMarked);
    [XYTaskService markTask:task successBlock:^(XYTask *resultTask) {
        
        [self.taskListModel loadTasks];
        [self hideProgressHudInView:self.view];
    } failureBlock:^{
        //show error
        [self hideProgressHudInView:self.view];
        [self showAlertWithTitle:nil andErrorMessage:@"Something went wrong, try again later"];
    }];

}

@end

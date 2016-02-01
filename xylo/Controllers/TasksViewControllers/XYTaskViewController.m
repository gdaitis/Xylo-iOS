//
//  XYTaskViewController.m
//  xylo
//
//  Created by Lukas Kekys on 02/09/14.
//  Copyright (c) 2014 Seriously. All rights reserved.
//

#import "XYTaskViewController.h"
#import "XYTaskDefaultCell.h"
#import "XYTaskDescriptionCell.h"
#import "XYTask+TaskFunctions.h"
#import "UIView+NibLoading.h"
#import "XYUtils.h"
#import "XYUser.h"
#import "UIImageView+AFNetworking.h"
#import "XYNavigationBarEditButton.h"

#define kTaskTableCellHeight 44
#define kDescriptionLabelWidht 253.0
#define kDescriptionCellRestContentHeight 43

@interface XYTaskViewController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;

@end

@implementation XYTaskViewController

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
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self showBackButton];
    [self addEditButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addEditButton
{
    XYNavigationBarEditButton *navigationBarEditButton = (XYNavigationBarEditButton *)[XYNavigationBarEditButton loadInstanceFromNib];
    [navigationBarEditButton.editButton addTarget:self action:@selector(editButtonSelected) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spacer.width = -8;
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:navigationBarEditButton];
    self.navigationItem.rightBarButtonItems = @[spacer, backItem];
}

- (void)editButtonSelected
{
    NSLog(@"EDIT");
}

#pragma mark - UITableView data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    return @"Testing text";
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int result = kTaskTableCellHeight;
    
    if (indexPath.row == 0) {
        
        //result must be calculated depending on text height
        UILabel *gettingSizeLabel = [[UILabel alloc] init];
        gettingSizeLabel.font = [UIFont fontWithName:@"OpenSans" size:13.0];
        gettingSizeLabel.text = self.currentTask.taskDescription;
        gettingSizeLabel.numberOfLines = 0;
        gettingSizeLabel.lineBreakMode = NSLineBreakByWordWrapping;
        CGSize maximumLabelSize = CGSizeMake(kDescriptionLabelWidht, 9999);
        
        CGSize expectSize = [gettingSizeLabel sizeThatFits:maximumLabelSize];
        result = expectSize.height + kDescriptionCellRestContentHeight;
    }
    return result;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        XYTaskDescriptionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XYTaskDescriptionCellID"];
        if (!cell) {
            cell = (XYTaskDescriptionCell *)[XYTaskDescriptionCell loadInstanceFromNib];
        }
        
        cell.nameLabel.text = self.currentTask.name;
        cell.descriptionLabel.text = self.currentTask.taskDescription;
        cell.completed = [self.currentTask.isCompleted boolValue];
        
        return cell;
    }
    else {
        XYTaskDefaultCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XYTaskDefaultCellID"];
        if (!cell) {
            cell = (XYTaskDefaultCell *)[XYTaskDefaultCell loadInstanceFromNib];
        }
        
        [self setupCell:cell forIndexPath:indexPath];
        return cell;
    }
}

- (void)setupCell:(XYTaskDefaultCell *)cell forIndexPath:(NSIndexPath *)indexPath
{
    [cell.rightImageView cancelImageRequestOperation];
    cell.rightImageView.image = nil;
    
    if (indexPath.row == 0) {
        cell.leftLabel.text = self.currentTask.taskDescription;
        cell.iconImageView.image = nil;
    }
    else if (indexPath.row == 1) {
        cell.iconImageView.image = [UIImage imageNamed:@"TaskDueDateIcon"];
        cell.leftLabel.text = @"Due Date:";
        cell.rightLabel.text = [XYUtils formatedLocalizedDateStringFromDate:self.currentTask.dueDate];
    }
    else if (indexPath.row == 2) {
        cell.iconImageView.image = [UIImage imageNamed:@"TaskRecuringIcon"];
        cell.leftLabel.text = @"Recuring:";
        cell.rightLabel.text = [self.currentTask taskRepeatString];
    }
    else {
        cell.iconImageView.image = [UIImage imageNamed:@"TaskViewAssignedByIcon"];
        cell.leftLabel.text = @"Assigned To:";
        cell.rightLabel.text = self.currentTask.asignedTo.username;
        
        [cell.rightImageView setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.currentTask.asignedTo.logoImageUrl]] placeholderImage:nil
                                            success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                                [cell.rightImageView setImage:image];
                                            } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                                
                                            }];
    }
}

#pragma mark - UITableView delegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSDictionary *resultDict = [XYUtils timeLeftFromDate:self.currentTask.dueDate];
    NSString *headerString = resultDict[@"resultString"];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 23)];
    view.backgroundColor = [UIColor colorWithRed:239.0f/255.0f green:243.0f/255.0f blue:245.0f/255.0f alpha:1.0f];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 7, tableView.frame.size.width - 20, 14)];
    titleLabel.font = [UIFont fontWithName:@"OpenSans" size:11];
    titleLabel.textColor = [UIColor colorWithRed:165.0f/255.0f green:182.0f/255.0f blue:191.0f/255.0f alpha:1.0f];
    titleLabel.text = headerString;
    
    [view addSubview:titleLabel];
    
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *result = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 1)];
    return result;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 23;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
}

@end

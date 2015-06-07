//
//  PopularFestivalsViewController.m
//  Festivalama
//
//  Created by Sztanyi Szabolcs on 02/06/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#import "PopularFestivalsViewController.h"
#import "FestivalTableViewCell.h"
#import "LoadingTableView.h"

@interface PopularFestivalsViewController ()

@end

@implementation PopularFestivalsViewController

//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    return self.festivalsArray.count;
//}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30.0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"test title - 2015";
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, CGRectGetWidth(tableView.frame), 30.0)];
    headerView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.2];

    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.0, 0.0, CGRectGetWidth(tableView.frame) - 30.0, 30.0)];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = [tableView.dataSource tableView:tableView titleForHeaderInSection:section];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14.0];
    [headerView addSubview:titleLabel];

    return headerView;
}

#pragma mark - view methods
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Beliebte Festivals";

    [self loadSavedFestivals];
}

- (void)loadSavedFestivals
{
    // TODO:

    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end

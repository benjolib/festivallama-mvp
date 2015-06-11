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
#import "FestivalDownloadClient.h"
#import "TableviewCounterView.h"
#import "FestivalRefreshControl.h"
#import "LoadingTableView.h"
#import "FestivalModel.h"


@interface PopularFestivalsViewController ()
@property (nonatomic, strong) FestivalDownloadClient *festivalDownloadClient;
@property (nonatomic) NSInteger limit;
@property (nonatomic) NSInteger startIndex;
@end

@implementation PopularFestivalsViewController

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.festivalsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FestivalTableViewCell *cell = (FestivalTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"cell"];
    FestivalModel *festival = self.festivalsArray[indexPath.row];

    cell.nameLabel.text = festival.name;
    cell.locationLabel.text = [festival locationAddress];
    NSString *timeString = [festival calendarDaysTillEndDateString];
    cell.timeLeftLabel.text = timeString;
    cell.calendarIcon.hidden = timeString.length == 0;

//    [cell setPopularityValue:festival.rank];

    return cell;
}

#pragma mark - download methods
- (void)refreshView
{
    self.startIndex = 0;
    [self.refreshController startRefreshing];

    [self.tableCounterView setCounterViewVisible:NO animated:NO];
    [self downloadPopularFestivals];
}

- (void)downloadPopularFestivals
{
    if (!self.festivalDownloadClient) {
        self.festivalDownloadClient = [FestivalDownloadClient new];
    }

    self.limit = 40.0;

    if (!self.festivalsArray) {
        self.festivalsArray = [NSMutableArray array];
    } else {
        [self.festivalsArray removeAllObjects];
    }

    __weak typeof(self) weakSelf = self;
    [self.festivalDownloadClient downloadPopularFestivalsFromIndex:self.startIndex limit:self.limit filterModel:nil andCompletionBlock:^(NSArray *festivalsArray, NSString *errorMessage, BOOL completed) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.tableView hideLoadingIndicator];
            if (completed) {
                [weakSelf.festivalsArray addObjectsFromArray:festivalsArray];

                [weakSelf.tableCounterView setTitle:[NSString stringWithFormat:@"%ld festivals", (unsigned long)weakSelf.festivalsArray.count]];
                [weakSelf.tableCounterView setCounterViewVisible:YES animated:YES];
            } else {
                // Handle errors

            }
            weakSelf.showLoadingIndicatorCell = NO;
            [weakSelf.tableView reloadData];
            [weakSelf.refreshController endRefreshing];
            if (weakSelf.tableView.contentOffset.y < 0) {
                weakSelf.tableView.contentOffset = CGPointMake(0.0, 0.0);
            }
        });
    }];
}

- (void)downloadNextFestivals
{

}

#pragma mark - view methods
- (void)viewDidLoad
{
    self.title = @"Beliebte Festivals";
    self.view.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundColor = [UIColor clearColor];
    [self addGradientBackground];

    [self prepareView];
    [self downloadPopularFestivals];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end

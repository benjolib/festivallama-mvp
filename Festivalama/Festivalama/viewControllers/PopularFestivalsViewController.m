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
#import "CoreDataHandler.h"

@interface PopularFestivalsViewController ()
@property (nonatomic, strong) FestivalDownloadClient *festivalDownloadClient;
@property (nonatomic) NSInteger limit;
@property (nonatomic) NSInteger startIndex;
@end

@implementation PopularFestivalsViewController

#pragma mark - searchnavigation view delegate methods
- (void)searchNavigationViewSearchButtonPressed:(NSString *)searchText
{
    self.isSearching = YES;
    self.searchText = searchText;

    [self searchForFestivals];
}

- (void)searchNavigationViewUserEnteredNewCharacter:(NSString *)searchText
{
    self.isSearching = YES;
    self.searchText = searchText;

    [self stopSearchTimer];
    [self startSearchTimer];
}

- (void)searchNavigationViewCancelButtonPressed
{
    self.isSearching = NO;
    self.searchText = @"";
    [self.tableView hideEmptySearchView];

    [self.festivalsArray removeAllObjects];
    [self searchForFestivals];
}

- (void)searchForFestivals
{
    self.startIndex = 0;
    [self downloadPopularFestivals];
}

#pragma mark - search timer
- (void)startSearchTimer
{
    [self stopSearchTimer];
    self.searchTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(searchForFestivals) userInfo:nil repeats:NO];
}

- (void)stopSearchTimer
{
    [self.searchTimer invalidate];
    self.searchTimer = nil;
}

#pragma mark - tableview methods
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
    NSString *timeString = [festival calendarDaysTillStartDateString];
    cell.timeLeftLabel.text = timeString;
    cell.calendarIcon.hidden = timeString.length == 0;

    [cell.calendarButton addTarget:self action:@selector(calenderButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [cell showSavedState:[[CoreDataHandler sharedHandler] isFestivalSaved:festival]];
    [cell setPopularityValue:festival.rank];

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

    NSInteger numberOfItemsBeforeUpdate = self.festivalsArray.count;
    __weak typeof(self) weakSelf = self;
    [self.festivalDownloadClient downloadPopularFestivalsFromIndex:self.startIndex limit:self.limit filterModel:nil andCompletionBlock:^(NSArray *festivalsArray, NSString *errorMessage, BOOL completed) {
        [weakSelf.tableView hideLoadingIndicator];
        if (completed) {
            if (weakSelf.isSearching) {
                weakSelf.festivalsArray = [festivalsArray mutableCopy];
            } else {
                [weakSelf.festivalsArray addObjectsFromArray:festivalsArray];
            }

            if (weakSelf.festivalsArray.count == 0 && weakSelf.isSearching) {
                [weakSelf.tableCounterView setCounterViewVisible:NO animated:YES];
            } else {
                [weakSelf.tableCounterView setCounterViewVisible:YES animated:YES];
                [weakSelf.tableCounterView displayTheNumberOfItems:(weakSelf.festivalsArray.count == 0 ? 0 : weakSelf.festivalsArray.count)];
            }
        } else {
            // Handle errors

        }
        weakSelf.showLoadingIndicatorCell = NO;
        if (numberOfItemsBeforeUpdate != weakSelf.festivalsArray.count) {
            [weakSelf.tableView reloadData];
        }
        [weakSelf.refreshController endRefreshing];
        if (weakSelf.tableView.contentOffset.y < 0) {
            weakSelf.tableView.contentOffset = CGPointMake(0.0, 0.0);
        }

        if (weakSelf.festivalsArray.count == 0 && weakSelf.isSearching) {
            [weakSelf.tableView showEmptySearchView];
        } else {
            [weakSelf.tableView hideEmptySearchView];
        }
    }];
}

- (void)downloadNextFestivals
{
    if ((self.startIndex + self.limit) < self.festivalsArray.count) {
        self.startIndex = self.festivalsArray.count;
    } else {
        self.startIndex = self.startIndex + self.limit;
    }
    [self downloadPopularFestivals];
}

#pragma mark - view methods
- (void)viewDidLoad
{
    self.title = @"Beliebte Festivals";
    self.view.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundColor = [UIColor clearColor];
    [self addGradientBackground];

    [self prepareView];
    self.startIndex = 0;
    [self.refreshController startRefreshing];

    [self.tableCounterView setCounterViewVisible:NO animated:NO];
    [self.tableView showLoadingIndicator];
    [self downloadPopularFestivals];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end

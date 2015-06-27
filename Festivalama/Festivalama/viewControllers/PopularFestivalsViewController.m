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
#import "FestivalLoadMoreTableViewCell.h"

@interface PopularFestivalsViewController ()
@property (nonatomic, strong) FestivalDownloadClient *festivalDownloadClient;
@property (nonatomic) NSInteger limit;
@property (nonatomic) NSInteger startIndex;
@property (nonatomic, strong) FilterModel *filterModel;
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
    [self.tableView hideEmptyView];

    [self.festivalsArray removeAllObjects];
    [self searchForFestivals];
}

- (void)searchForFestivals
{
    self.startIndex = 0;
    [self downloadAllFestivals];
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
    return self.showLoadingIndicatorCell ? self.festivalsArray.count+1 : self.festivalsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.showLoadingIndicatorCell && indexPath.row == self.festivalsArray.count) {
        FestivalLoadMoreTableViewCell *reloadCell = (FestivalLoadMoreTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"reloadCell"];
        if (!reloadCell) {
            reloadCell = [[FestivalLoadMoreTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"reloadCell"];
        }

        reloadCell.backgroundColor = [UIColor clearColor];
        return reloadCell;
    }

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
- (void)downloadAllFestivals
{
    if (!self.festivalDownloadClient) {
        self.festivalDownloadClient = [FestivalDownloadClient new];
    }

    self.limit = 40.0;

    if (!self.festivalsArray) {
        self.festivalsArray = [NSMutableArray array];
    }

    __weak typeof(self) weakSelf = self;
    [self.festivalDownloadClient downloadPopularFestivalsFromIndex:self.startIndex
                                                             limit:self.limit
                                                        searchText:self.searchText
                                                       filterModel:self.filterModel
                                                andCompletionBlock:^(NSArray *festivalsArray, NSString *errorMessage, BOOL completed) {
                                                    [weakSelf handleDownloadedFestivals:festivalsArray error:errorMessage];
    }];
}

- (void)filterContent:(NSNotification*)notification
{
    if ([[FilterModel sharedModel] isFiltering])
    {
        self.filterModel = [FilterModel sharedModel];
        [[FilterModel sharedModel] clearFilters];

        [self downloadAllFestivals];
    }
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
    self.showLoadingIndicatorCell = NO;

    [self.tableCounterView setCounterViewVisible:NO animated:NO];
    [self.tableView showLoadingIndicator];
    [self downloadAllFestivals];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(filterContent:) name:@"festivalFilterEnabled" object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end

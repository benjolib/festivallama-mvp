//
//  FestivalsViewController.m
//  Festivalama
//
//  Created by Sztanyi Szabolcs on 01/06/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#import "FestivalsViewController.h"
#import "TableviewCounterView.h"
#import "StoryboardManager.h"
#import "FilterNavigationController.h"
#import "FestivalTableViewCell.h"
#import "FestivalDownloadClient.h"
#import "MenuTransitionManager.h"
#import "FestivalModel.h"
#import "FestivalRefreshControl.h"
#import "LoadingTableView.h"
#import "FestivalDetailViewController.h"
#import "TutorialPopupView.h"
#import "GeneralSettings.h"
#import "CoreDataHandler.h"
#import "FestivalRankClient.h"
#import "FestivalLoadMoreTableViewCell.h"
#import "TrackingManager.h"
#import "GreenButton.h"
#import "FilterModel.h"

@interface FestivalsViewController ()
@property (nonatomic, strong) MenuTransitionManager *menuTransitionManager;
@property (nonatomic, strong) FestivalDownloadClient *festivalDownloadClient;
@property (nonatomic, strong) FestivalRankClient *rankClient;
@property (nonatomic) NSInteger limit;
@property (nonatomic) NSInteger startIndex;
@end

@implementation FestivalsViewController

- (IBAction)filterButtonPressed:(id)sender
{
    [[TrackingManager sharedManager] trackOpenFilterView];

    FilterNavigationController *filterNav = [StoryboardManager filterNavigationController];
    [self presentViewController:filterNav animated:YES completion:nil];
}

- (IBAction)trashButtonPressed:(id)sender
{
    [[FilterModel sharedModel] clearFilters];
    self.trashIcon.hidden = ![FilterModel.sharedModel isFiltering];
    [self refreshView];
}

- (void)calenderButtonTapped:(UIButton*)button
{
    UIView *aSuperview = [button superview];
    while (![aSuperview isKindOfClass:[FestivalTableViewCell class]]) {
        aSuperview = [aSuperview superview];
    }

    FestivalTableViewCell *cell = (FestivalTableViewCell*)aSuperview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    FestivalModel *festival = self.festivalsArray[indexPath.row];

    BOOL alreadyExisting = [[CoreDataHandler sharedHandler] addFestivalToFavorites:festival];
    if (alreadyExisting) {
        [[TrackingManager sharedManager] trackUserRemovedFestival];
    } else {
        [[TrackingManager sharedManager] trackUserAddedFestival];
    }
    [self sendRankInformationAboutSelectedFestival:festival increment:!alreadyExisting];
    [self.tableView reloadData];
}

- (void)sendRankInformationAboutSelectedFestival:(FestivalModel*)festival increment:(BOOL)increment
{
    self.rankClient = [[FestivalRankClient alloc] init];
    [self.rankClient sendRankingForFestival:festival increment:increment withCompletionBlock:^(BOOL succeeded, NSString *errorMessage) {
        if (!succeeded) {
            // TODO: error handling
        }
    }];
}

#pragma mark - tableView methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.showLoadingIndicatorCell ? self.festivalsArray.count + 1 : self.festivalsArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.festivalsArray.count && self.showLoadingIndicatorCell) {
        return 44.0;
    }
    return 85.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FestivalTableViewCell *cell = (FestivalTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"cell"];

    if (self.showLoadingIndicatorCell && indexPath.row == self.festivalsArray.count) {
        FestivalLoadMoreTableViewCell *reloadCell = (FestivalLoadMoreTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"reloadCell"];
        if (!reloadCell) {
            reloadCell = [[FestivalLoadMoreTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"reloadCell"];
        }

        reloadCell.backgroundColor = [UIColor clearColor];
        return reloadCell;
    }

    FestivalModel *festival = self.festivalsArray[indexPath.row];

    cell.nameLabel.text = festival.name;
    cell.locationLabel.text = [festival locationAddress];
    NSString *timeString = [festival calendarDaysTillStartDateString];
    cell.timeLeftLabel.text = timeString;
    cell.calendarIcon.hidden = timeString.length == 0;

    [cell showSavedState:[[CoreDataHandler sharedHandler] isFestivalSaved:festival]];

    [cell.calendarButton addTarget:self action:@selector(calenderButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [cell setPopularityValue:0];

    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger lastRowIndex = [tableView numberOfRowsInSection:0] - 1;
    if ((indexPath.row == lastRowIndex) && (self.festivalsArray.count >= self.limit) && !self.isSearching)
    {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            UITableViewCell *reloadCell = [tableView cellForRowAtIndexPath:indexPath];
            if ([reloadCell isKindOfClass:[FestivalLoadMoreTableViewCell class]]) {
                FestivalLoadMoreTableViewCell *cell = (FestivalLoadMoreTableViewCell*)reloadCell;
                [cell startRefreshing];
            }

            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self downloadNextFestivals];
            });
        });
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [self performSegueWithIdentifier:@"openFestivalDetailView" sender:cell];

    [[TrackingManager sharedManager] trackSelectsFestival];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([sender isKindOfClass:[UITableViewCell class]] && [segue.identifier isEqualToString:@"openFestivalDetailView"]) {
        UITableViewCell *cell = (UITableViewCell*)sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];

        FestivalModel *festival = self.festivalsArray[indexPath.row];

        FestivalDetailViewController *detailViewController = (FestivalDetailViewController*)segue.destinationViewController;
        detailViewController.festivalToDisplay = festival;
    }
}

#pragma mark - downloading methods
- (void)refreshView
{
    self.startIndex = 0;
    [self.refreshController startRefreshing];

    [self.tableCounterView setCounterViewVisible:NO animated:NO];
    [self downloadAllFestivals];
}

- (void)downloadNextFestivals
{
    if ((self.startIndex + self.limit) < self.festivalsArray.count) {
        self.startIndex = self.festivalsArray.count;
    } else {
        self.startIndex = self.startIndex + self.limit;
    }
    [self downloadAllFestivals];
}

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
    [self.festivalDownloadClient downloadFestivalsFromIndex:self.startIndex
                                                      limit:self.limit
                                                filterModel:[FilterModel sharedModel]
                                                 searchText:self.searchText
                                         andCompletionBlock:^(NSArray *festivalsArray, NSString *errorMessage, BOOL completed) {
                                             [weakSelf handleDownloadedFestivals:festivalsArray error:errorMessage];
    }];
}

- (void)handleDownloadedFestivals:(NSArray*)festivals error:(NSString*)errorMessage
{
    [self.tableView hideLoadingIndicator];
    if (!errorMessage) {
        if (self.isSearching) {
            self.festivalsArray = [festivals mutableCopy];
        } else {
            if (self.startIndex == 0) {
                self.festivalsArray = [festivals mutableCopy];
            } else {
                [self.festivalsArray addObjectsFromArray:festivals];
            }
        }

        if (festivals.count == 0) {
            self.startIndex = self.festivalsArray.count;
            self.showLoadingIndicatorCell = NO;
        }
        // only allow showing the loading more cell indicator, when the number of returned items equal to the limit,
        // cause then we can assume that there are more object to come
        self.showLoadingIndicatorCell = festivals.count == self.limit;

        if (self.festivalsArray.count == 0 && self.isSearching) {
            [self.tableCounterView setCounterViewVisible:NO animated:YES];
        } else {
            if (self.festivalsArray.count > 6) {
                [self.tableCounterView setCounterViewVisible:YES animated:YES];
            } else {
                [self.tableCounterView setCounterViewVisible:NO animated:YES];
            }
        }
        [self.tableCounterView displayTheNumberOfItems:(self.festivalsArray.count == 0 ? 0 : self.festivalsArray.count)];
    }

    [self.tableView reloadData];
    [self.refreshController endRefreshing];
    if (self.tableView.contentOffset.y < 0) {
        self.tableView.contentOffset = CGPointMake(0.0, 0.0);
    }

    if (self.festivalsArray.count == 0) {
        if (self.isSearching) {
            [self.tableView showEmptySearchView];
        } else if ([[FilterModel sharedModel] isFiltering]) {
            [self.tableView showEmptyFilterView];
        }
    } else {
        [self.tableView hideEmptyView];
    }
}

- (void)filterContent:(NSNotification*)notification
{
    if ([[FilterModel sharedModel] isFiltering]) {
        [self downloadAllFestivals];
    }
}

#pragma mark - searching
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

#pragma mark - view methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.refreshController parentScrollViewDidScroll:scrollView];
    if (scrollView.contentOffset.y >= 0 && scrollView.contentOffset.y <= 30.0) {
        [self.tableCounterView setCounterViewVisible:YES animated:YES];
    } else {
        [self.tableCounterView setCounterViewVisible:NO animated:YES];
    }
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView
{
    [self.tableCounterView setCounterViewVisible:YES animated:YES];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self.refreshController parentScrollViewDidEndDragging:scrollView];
    if (scrollView.contentOffset.y >= 0 && scrollView.contentOffset.y <= 30.0) {
        [self.tableCounterView setCounterViewVisible:YES animated:YES];
    } else {
        [self.tableCounterView setCounterViewVisible:NO animated:YES];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    super.title = @"Festivals";

    self.showLoadingIndicatorCell = NO;
    [self prepareView];
    [self.tableView showLoadingIndicator];
    [self refreshView];

    [GeneralSettings saveAppStartDate];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(filterContent:) name:@"festivalFilterEnabled" object:nil];
}

- (void)prepareView
{
    [self.tableView registerNib:[UINib nibWithNibName:@"FestivalTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"cell"];

    self.tableCounterView = [[TableviewCounterView alloc] initWithFrame:CGRectZero];
    [self.tableCounterView addToView:self.view];

    self.refreshController = [[FestivalRefreshControl alloc] initWithFrame:CGRectMake(0.0, -50.0, CGRectGetWidth(self.view.frame), 50.0)];
    [self.tableView addSubview:self.refreshController];

    [self.refreshController addTarget:self
                               action:@selector(refreshView)
                     forControlEvents:UIControlEventValueChanged];
}

- (void)showTutorialPopup
{
    TutorialPopupView *tutorial2 = [[TutorialPopupView alloc] init];
    [tutorial2 showWithText:@"Filtere die Ergebniss nach Musik Genre, Künstler oder Ort"
                    atPoint:CGPointMake(CGRectGetMidX(self.applyButton.frame), CGRectGetMinY(self.applyButton.frame)-50.0)
              highLightArea:self.applyButton.frame];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    if (![GeneralSettings wasTutorialShown]) {
        [self showTutorialPopup];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.trashIcon.hidden = ![FilterModel.sharedModel isFiltering];
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

//
//  FestivalsViewController.m
//  Festivalama
//
//  Created by Sztanyi Szabolcs on 01/06/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#import "FestivalsViewController.h"
#import "FilterButton.h"
#import "TableviewCounterView.h"
#import "StoryboardManager.h"
#import "FilterNavigationController.h"
#import "FestivalTableViewCell.h"
#import "FestivalDownloadClient.h"
#import "MenuTransitionManager.h"
#import "FestivalModel.h"
#import "FestivalRefreshControl.h"
#import "LoadingTableView.h"
#import "FilterModel.h"
#import "FestivalDetailViewController.h"
#import "TutorialPopupView.h"
#import "GeneralSettings.h"
#import "CoreDataHandler.h"
#import "LoadMoreTableViewCell.h"
#import "FestivalRankClient.h"

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
    FilterNavigationController *filterNav = [StoryboardManager filterNavigationController];
    [self presentViewController:filterNav animated:YES completion:nil];
}

- (IBAction)trashButtonPressed:(id)sender
{
    [[FilterModel sharedModel] clearFilters];
    self.trashIcon.hidden = ![FilterModel.sharedModel isFiltering];
    [self downloadAllFestivals];
}

- (void)calenderButtonTapped:(UIButton*)button
{
    if (![button.superview.superview isKindOfClass:[FestivalTableViewCell class]]) {
        return;
    }

    FestivalTableViewCell *cell = (FestivalTableViewCell*)button.superview.superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    FestivalModel *festival = self.festivalsArray[indexPath.row];

    BOOL alreadyExisting = [[CoreDataHandler sharedHandler] addFestivalToFavorites:festival];
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
//        return self.festivalsArray.count + 1;
    return self.festivalsArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (indexPath.row == self.festivalsArray.count) {
//        return 44.0;
//    }
    return 85.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FestivalTableViewCell *cell = (FestivalTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"cell"];

//    if (/*self.showLoadingIndicatorCell && */ indexPath.row == self.festivalsArray.count) {
//        LoadMoreTableViewCell *reloadCell = (LoadMoreTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"reloadCell"];
//        if (!reloadCell) {
//            reloadCell = [[LoadMoreTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"reloadCell"];
//        }
//
//        reloadCell.textLabel.text = @"Loading more...";
//        reloadCell.backgroundColor = [UIColor clearColor];
//        reloadCell.textLabel.textColor = [UIColor whiteColor];
//
//        return reloadCell;
//    }

    FestivalModel *festival = self.festivalsArray[indexPath.row];

    cell.nameLabel.text = festival.name;
    cell.locationLabel.text = [festival locationAddress];
    NSString *timeString = [festival calendarDaysTillEndDateString];
    cell.timeLeftLabel.text = timeString;
    cell.calendarIcon.hidden = timeString.length == 0;

    [cell showSavedState:[[CoreDataHandler sharedHandler] isFestivalSaved:festival]];

    [cell.calendarButton addTarget:self action:@selector(calenderButtonTapped:) forControlEvents:UIControlEventTouchUpInside];

    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [(FestivalTableViewCell*)cell hidePopularityView];

    NSInteger lastSectionIndex = [tableView numberOfSections] - 1;
    NSInteger lastRowIndex = [tableView numberOfRowsInSection:lastSectionIndex] - 1;
    if ((indexPath.section == lastSectionIndex) && (indexPath.row == lastRowIndex) && (tableView.visibleCells.count < self.festivalsArray.count))
    {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.showLoadingIndicatorCell = YES;

//            LoadMoreTableViewCell *reloadCell = (LoadMoreTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
//            [reloadCell showLoadingIndicator];

            [self downloadNextFestivals];
        });
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [self performSegueWithIdentifier:@"openFestivalDetailView" sender:cell];
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
    [self.festivalDownloadClient downloadFestivalsFromIndex:self.startIndex limit:self.limit filterModel:[FilterModel sharedModel] andCompletionBlock:^(NSArray *festivalsArray, NSString *errorMessage, BOOL completed) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.tableView hideLoadingIndicator];
            if (completed) {
                [weakSelf.festivalsArray addObjectsFromArray:festivalsArray];

                [weakSelf.tableCounterView displayTheNumberOfItems:weakSelf.festivalsArray.count];
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
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.startIndex = self.startIndex + self.limit;
        [self downloadAllFestivals];
//    });
}

- (void)filterContent:(NSNotification*)notification
{
    if([FilterModel.sharedModel isFiltering]) {
        [self downloadAllFestivals];
    }
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

    [self prepareView];
    [self.tableView showLoadingIndicator];
    [self refreshView];

//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(filterContent:) name:@"festivalFilterEnabled" object:nil];
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

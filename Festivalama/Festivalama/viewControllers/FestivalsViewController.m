//
//  FestivalsViewController.m
//  Festivalama
//
//  Created by Sztanyi Szabolcs on 01/06/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#import "FestivalsViewController.h"
#import "GreenButton.h"
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

@interface FestivalsViewController ()
@property (nonatomic, strong) TableviewCounterView *tableCounterView;
@property (nonatomic, strong) MenuTransitionManager *menuTransitionManager;
@property (nonatomic, strong) FestivalDownloadClient *festivalDownloadClient;
@property (nonatomic, strong) FestivalRefreshControl *refreshController;
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

}

#pragma mark - tableView methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.festivalsArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 85.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FestivalTableViewCell *cell = (FestivalTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"cell"];

    FestivalModel *festival = self.festivalsArray[indexPath.row];

    cell.nameLabel.text = festival.name;
    cell.locationLabel.text = [festival locationAddress];
    cell.timeLeftLabel.text = [festival calendarDaysTillEndDateString];

    return cell;
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
    [self.festivalDownloadClient downloadFestivalsFromIndex:self.startIndex limit:self.limit filterModel:nil andCompletionBlock:^(NSArray *festivalsArray, NSString *errorMessage, BOOL completed) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.tableView hideLoadingIndicator];
            if (completed) {
                [weakSelf.festivalsArray addObjectsFromArray:festivalsArray];

                [weakSelf.tableCounterView setTitle:[NSString stringWithFormat:@"%ld festivals", (unsigned long)festivalsArray.count]];
                [weakSelf.tableCounterView setCounterViewVisible:YES animated:YES];
            } else {
                // Handle errors

            }
            [weakSelf.tableView reloadData];
            [weakSelf.refreshController endRefreshing];
            weakSelf.tableView.contentOffset = CGPointMake(0.0, 0.0);
        });
    }];
}

- (void)downloadNextFestivals
{
    self.startIndex = self.startIndex + self.limit;
    [self downloadAllFestivals];
}

#pragma mark - view methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.refreshController parentScrollViewDidScroll:scrollView];
    [self.tableCounterView setCounterViewVisible:NO animated:NO];
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView
{
    [self.tableCounterView setCounterViewVisible:YES animated:YES];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self.tableCounterView setCounterViewVisible:NO animated:NO];
    [self.refreshController parentScrollViewDidEndDragging:scrollView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    super.title = @"Festivals";

    [self.tableView registerNib:[UINib nibWithNibName:@"FestivalTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"cell"];

    self.tableCounterView = [[TableviewCounterView alloc] initWithFrame:CGRectZero];
    [self.tableCounterView addToView:self.view];

    self.refreshController = [[FestivalRefreshControl alloc] initWithFrame:CGRectMake(0.0, -50.0, CGRectGetWidth(self.view.frame), 50.0)];
    [self.tableView addSubview:self.refreshController];

    [self.refreshController addTarget:self
                               action:@selector(refreshView)
                     forControlEvents:UIControlEventValueChanged];

    [self.tableView showLoadingIndicator];
    [self refreshView];
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

}

@end

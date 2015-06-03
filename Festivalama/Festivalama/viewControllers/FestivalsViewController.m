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

@interface FestivalsViewController ()
@property (nonatomic, strong) TableviewCounterView *tableCounterView;
@property (nonatomic, strong) NSMutableArray *festivalsArray;
@property (nonatomic, strong) MenuTransitionManager *menuTransitionManager;
@property (nonatomic, strong) FestivalDownloadClient *festivalDownloadClient;
@property (nonatomic, strong) FestivalRefreshControl *refreshController;
@property (nonatomic) NSInteger limit;
@property (nonatomic) NSInteger startIndex;
@end

@implementation FestivalsViewController

- (IBAction)menuButtonPressed:(id)sender
{
    self.menuTransitionManager = [MenuTransitionManager new];
    [self.menuTransitionManager presentMenuViewControllerOnViewController:self];
}

- (IBAction)searchButtonPressed:(id)sender
{
    
}

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
    cell.timeLeftLabel.text = @"In Some stuff";

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
        if (completed) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.festivalsArray addObjectsFromArray:festivalsArray];

                [weakSelf.tableCounterView setTitle:[NSString stringWithFormat:@"%ld festivals", festivalsArray.count]];
                [weakSelf.tableCounterView setCounterViewVisible:YES animated:YES];
                [weakSelf.tableView reloadData];
                [weakSelf.refreshController endRefreshing];
                weakSelf.tableView.contentOffset = CGPointMake(0.0, 0.0);
            });
        } else {
            // Handle errors
        }
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
//    if (scrollView.contentOffset.y > 30.0) {
        [self.tableCounterView setCounterViewVisible:NO animated:NO];
//    } else {
//        [self.tableCounterView setCounterViewVisible:YES animated:YES];
//    }
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView
{
    [self.tableCounterView setCounterViewVisible:YES animated:YES];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    CGFloat minOffsetToTriggerRefresh = 50.0f;
    if (scrollView.contentOffset.y <= -minOffsetToTriggerRefresh) {
        [self.tableCounterView setCounterViewVisible:NO animated:NO];
        [self.refreshController containingScrollViewDidEndDragging:scrollView];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Festivals";

    [self.tableView registerNib:[UINib nibWithNibName:@"FestivalTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"cell"];

    self.tableCounterView = [[TableviewCounterView alloc] initWithFrame:CGRectZero];
    [self.tableCounterView addToView:self.view];

    self.refreshController = [[FestivalRefreshControl alloc] initWithFrame:CGRectMake(0.0, -50.0, CGRectGetWidth(self.view.frame), 50.0)];
    [self.tableView addSubview:self.refreshController];

    [self.refreshController addTarget:self
                               action:@selector(refreshView)
                     forControlEvents:UIControlEventValueChanged];

    [self refreshView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
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

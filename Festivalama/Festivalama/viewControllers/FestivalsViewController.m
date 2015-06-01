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

@interface FestivalsViewController ()
@property (nonatomic, strong) TableviewCounterView *tableCounterView;
@property (nonatomic, strong) NSArray *festivalsArray;
@property (nonatomic, strong) MenuTransitionManager *menuTransitionManager;
@property (nonatomic, strong) FestivalDownloadClient *festivalDownloadClient;
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
- (void)downloadAllFestivals
{
    if (!self.festivalDownloadClient) {
        self.festivalDownloadClient = [FestivalDownloadClient new];
    }

    __weak typeof(self) weakSelf = self;
    [self.festivalDownloadClient downloadAllFestivalsWithCompletionBlock:^(NSArray *festivalsArray, NSString *errorMessage, BOOL completed) {
        if (completed) {
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.festivalsArray = [festivalsArray copy];
                [weakSelf.tableView reloadData];
                [weakSelf.tableCounterView setTitle:[NSString stringWithFormat:@"%ld festivals", festivalsArray.count]];
                [weakSelf.tableCounterView setCounterViewVisible:YES];
            });
        } else {
            // Handle errors
        }
    }];
}

#pragma mark - view methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y > 30.0) {
        [self.tableCounterView setCounterViewVisible:NO];
    } else {
        [self.tableCounterView setCounterViewVisible:YES];
    }
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView
{
    [self.tableCounterView setCounterViewVisible:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Festivals";

    self.tableCounterView = [[TableviewCounterView alloc] initWithFrame:CGRectZero];
    [self.tableCounterView addToView:self.view];

    [self downloadAllFestivals];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (self.tableView.contentOffset.y < 30.0 && [self.tableCounterView hasTitle]) {
        [self.tableCounterView setCounterViewVisible:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)dealloc
{

}

@end

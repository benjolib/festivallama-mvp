//
//  FilterViewController.m
//  Festivalama
//
//  Created by Sztanyi Szabolcs on 31/05/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#import "FilterViewController.h"
#import "GreenButton.h"
#import "UIColor+AppColors.h"
#import "FilterTableViewCell.h"
#import "FilterBandsTableViewCell.h"
#import "GenreDownloadClient.h"
#import "BandsDownloadClient.h"
#import "FilterGenresViewController.h"
#import "FilterBandsViewController.h"
#import "UIFont+LatoFonts.h"
#import "TrackingManager.h"

#define IS_iOS8 [[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0

@interface FilterViewController ()
@property (nonatomic, strong) GenreDownloadClient *genreDownloadClient;
@property (nonatomic, strong) BandsDownloadClient *bandsDownloadClient;
@property (nonatomic, strong, readwrite) NSArray *genresArray;
@property (nonatomic, strong) NSArray *allBandsArray;
@end

@implementation FilterViewController

- (IBAction)backButtonPressed:(id)sender
{
    [[TrackingManager sharedManager] trackFilterBackbutton];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)applyButtonPressed:(id)sender
{
    if ([[FilterModel sharedModel] isFiltering]) {
        [[TrackingManager sharedManager] trackFilterSelectsFilterButtonWithFilters];
    } else {
        [[TrackingManager sharedManager] trackFilterSelectsFilterButtonWithoutFilters];
    }

    [[NSNotificationCenter defaultCenter] postNotificationName:@"festivalFilterEnabled" object:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)trashButtonPressed:(id)sender
{
    [[TrackingManager sharedManager] trackFilterTapsTrashIconMain];
    [[FilterModel sharedModel] clearFilters];
    [self adjustButtonToFilterModel];
    [self.tableView reloadData];
}

- (void)downloadGenresWithCompletionBlock:(void(^)())completionBlock
{
    self.genreDownloadClient = [GenreDownloadClient new];

    __weak typeof(self) weakSelf = self;
    [self.genreDownloadClient downloadAllGenresWithCompletionBlock:^(NSArray *sortedGenres, NSString *errorMessage, BOOL completed) {
        if (completed) {
            weakSelf.genresArray = [sortedGenres copy];
        }
        if (completionBlock) {
            completionBlock();
        }
    }];
}

- (void)downloadBandsWithCompletionBlock:(void(^)())completionBlock
{
    self.bandsDownloadClient = [BandsDownloadClient new];

    __weak typeof(self) weakSelf = self;
    [self.bandsDownloadClient downloadAllBandsWithCompletionBlock:^(NSArray *sortedBands, NSString *errorMessage, BOOL completed) {
        if (completed) {
            weakSelf.allBandsArray = [sortedBands copy];
        }
        if (completionBlock) {
            completionBlock();
        }
    }];
}

- (void)setTrashIconVisible:(BOOL)visible
{
    self.trashIcon.alpha = visible ? 1.0 : 0.2;
}

- (void)adjustButtonToFilterModel
{
    if ([[FilterModel sharedModel] isFiltering]) {
        [self setTrashIconVisible:YES];
        [self.applyButton setTitle:@"Suchen" forState:UIControlStateNormal];
    } else {
        [self setTrashIconVisible:NO];
        [self.applyButton setTitle:@"Suchen" forState:UIControlStateNormal];
    }
}

- (void)bandCellTrashButtonPressed:(UIButton*)button
{
    [[TrackingManager sharedManager] trackFilterTapsTrashIconOnMainBandCell];
    [FilterModel sharedModel].selectedBandsArray = [NSArray array];
    [self.tableView reloadData];
}

- (void)setFilteringEnabled:(BOOL)enabled
{
    if (enabled) {
        [self setTrashIconVisible:YES];
        [self.applyButton setTitle:@"Suchen" forState:UIControlStateNormal];
    } else {
        [self setTrashIconVisible:NO];
        [self.applyButton setTitle:@"Suchen" forState:UIControlStateNormal];
    }
}

#pragma mark - tableView methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (IS_iOS8) {
        return UITableViewAutomaticDimension;
    }
    return 81.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 1) {
        FilterBandsTableViewCell *cell = (FilterBandsTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"bandsCell"];

        NSString *bandsString = [[FilterModel sharedModel] bandsString];
        if (bandsString.length > 0) {
            cell.trashButton.userInteractionEnabled = YES;
            [cell.trashButton addTarget:self action:@selector(bandCellTrashButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            [cell.trashButton setImage:[UIImage imageNamed:@"trashIcon"] forState:UIControlStateNormal];
        } else {
            cell.trashButton.userInteractionEnabled = NO;
            [cell.trashButton setImage:[UIImage imageNamed:@"disclosureIcon"] forState:UIControlStateNormal];
        }

        cell.accessoryView = nil;
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.backgroundColor = [UIColor clearColor];
        cell.nameLabel.text = @"Nach Künstlern";
        cell.bandDetailLabel.text = bandsString;
        return cell;
    } else {
        FilterTableViewCell *cell = (FilterTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"basicCell"];

        UIImageView *accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"disclosureIcon"]];
        cell.accessoryView = accessoryView;

        if (indexPath.row == 0) {
            cell.nameLabel.text = @"Nach Musik Genre";
        } else {
            cell.nameLabel.text = @"Nach Ort";
        }
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        [self performSegueWithIdentifier:@"openGenres" sender:nil];
        [[TrackingManager sharedManager] trackFilterSelectsGenreView];
    } else if (indexPath.row == 1) {
        if (self.allBandsArray) {
            [[TrackingManager sharedManager] trackFilterSelectsBandsView];
            [self performSegueWithIdentifier:@"openBands" sender:nil];
        } else {
            __weak typeof(self) weakSelf = self;
            [self downloadBandsWithCompletionBlock:^{
                [[TrackingManager sharedManager] trackFilterSelectsBandsView];
                [weakSelf performSegueWithIdentifier:@"openBands" sender:nil];
            }];
        }
    } else {
        [[TrackingManager sharedManager] trackFilterSelectsPlaceView];
        [self performSegueWithIdentifier:@"showLocation" sender:nil];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"openGenres"]) {
        FilterGenresViewController *genresViewController = (FilterGenresViewController*)segue.destinationViewController;
        genresViewController.allGenresArray = [self.genresArray copy];
    } else if ([segue.identifier isEqualToString:@"openBands"]) {
        FilterBandsViewController *bandsTableViewController = (FilterBandsViewController*)segue.destinationViewController;
        bandsTableViewController.allBandsArray = [self.allBandsArray copy];
    }
}

#pragma mark - view methods
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Filter";

    self.applyButton.titleLabel.font = [UIFont latoRegularFontWithSize:17.0];

    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.estimatedRowHeight = 70.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self downloadGenresWithCompletionBlock:nil];
    [self downloadBandsWithCompletionBlock:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
    [self adjustButtonToFilterModel];
}

- (IBAction)searchCancelButtonTapped:(id)sender
{
    // implemented in subclasses
}

- (void)searchFieldTextChanged:(UITextField*)textfield
{
    // implemented in subclasses
}

- (void)setupSearchView
{
    self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    self.tableView.sectionIndexColor = [UIColor whiteColor];
    self.tableView.sectionIndexMinimumDisplayRowCount = 20;

    self.searchWrapperView.backgroundColor = [UIColor clearColor];
    self.searchField.layer.cornerRadius = 6.0;
    self.searchField.layer.borderWidth = 1.0;
    self.searchField.layer.borderColor = [UIColor colorWithWhite:1.0 alpha:0.2].CGColor;
    self.searchField.textColor = [UIColor whiteColor];
    self.searchField.tintColor = [UIColor whiteColor];

    self.searchField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.searchField.placeholder
                                                                           attributes:@{NSForegroundColorAttributeName: [UIColor colorWithWhite:1.0 alpha:0.5]}];

    UIView *leftSpacerView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 10.0, 0.0)];
    leftSpacerView.backgroundColor = [UIColor clearColor];
    self.searchField.leftView = leftSpacerView;
    self.searchField.leftViewMode = UITextFieldViewModeAlways;

    [self.searchField addTarget:self action:@selector(searchFieldTextChanged:) forControlEvents:UIControlEventEditingChanged];


    [self.searchCancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.searchCancelButton setTitleColor:[UIColor colorWithWhite:1.0 alpha:0.6] forState:UIControlStateHighlighted];

    self.searchWrapperViewTrailingConstraint.constant = 0.0;
    self.searchCancelButtonWidthConstraint.constant = 0.0;
    [UIView animateWithDuration:0.2 animations:^{
        [self.searchWrapperView layoutIfNeeded];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)dealloc
{
    self.allBandsArray = nil;
    self.genresArray = nil;
    self.genreDownloadClient = nil;
    self.bandsDownloadClient = nil;
}

@end

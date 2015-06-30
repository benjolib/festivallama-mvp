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
#import "FilterGenresViewController.h"
#import "FilterBandsViewController.h"
#import "UIFont+LatoFonts.h"
#import "TrackingManager.h"

#define IS_iOS8 [[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0

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

- (void)cellTrashButtonPressed:(UIButton*)button
{
    UIView *aSuperview = [button superview];
    while (![aSuperview isKindOfClass:[FilterBandsTableViewCell class]]) {
        aSuperview = [aSuperview superview];
    }

    FilterBandsTableViewCell *cell = (FilterBandsTableViewCell*)aSuperview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];

    if (indexPath.row == 0) {
        [FilterModel sharedModel].selectedGenresArray = [NSArray array];
    } else if (indexPath.row == 1) {
        [FilterModel sharedModel].selectedBandsArray = [NSArray array];
    } else if (indexPath.row == 2) {
        [FilterModel sharedModel].selectedPostcodesArray = [NSArray array];
        [FilterModel sharedModel].selectedCountriesArray = [NSArray array];
    }

    [[TrackingManager sharedManager] trackFilterTapsTrashIconOnMainBandCell];
    [self.tableView reloadData];

    [self adjustButtonToFilterModel];
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
    FilterBandsTableViewCell *cell = (FilterBandsTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"bandsCell"];
    cell.accessoryView = nil;
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.backgroundColor = [UIColor clearColor];

    BOOL enableTrashIcon = NO;

    if (indexPath.row == 1)
    {
        NSString *bandsString = [[FilterModel sharedModel] bandsString];
        if (bandsString.length > 0) {
            enableTrashIcon = YES;
        } else {
            enableTrashIcon = NO;
        }
        cell.nameLabel.text = @"Nach Künstlern";
        cell.bandDetailLabel.text = bandsString;
    }
    else
    {
        if (indexPath.row == 0) {
            NSString *genresString = [[FilterModel sharedModel] genresString];
            if (genresString.length > 0) {
                enableTrashIcon = YES;
            }
            cell.nameLabel.text = @"Nach Musik Genre";
            cell.bandDetailLabel.text = genresString;
        } else {
            cell.nameLabel.text = @"Nach Ort";
            if ([[FilterModel sharedModel] selectedCountriesArray].count > 0) {
                enableTrashIcon = YES;
                cell.bandDetailLabel.text = @"Land ausgewählt";
            } else if ([[FilterModel sharedModel] selectedPostcodesArray].count > 0) {
                enableTrashIcon = YES;
                cell.bandDetailLabel.text = @"Ort ausgewählt";
            } else {
                enableTrashIcon = NO;
                cell.bandDetailLabel.text = @"";
            }
        }
    }

    if (enableTrashIcon) {
        cell.trashButton.userInteractionEnabled = YES;
        [cell.trashButton addTarget:self action:@selector(cellTrashButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [cell.trashButton setImage:[UIImage imageNamed:@"trashIcon"] forState:UIControlStateNormal];
    } else {
        cell.trashButton.userInteractionEnabled = NO;
        [cell.trashButton setImage:[UIImage imageNamed:@"disclosureIcon"] forState:UIControlStateNormal];
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        [self performSegueWithIdentifier:@"openGenres" sender:nil];
        [[TrackingManager sharedManager] trackFilterSelectsGenreView];
    } else if (indexPath.row == 1) {
        [[TrackingManager sharedManager] trackFilterSelectsBandsView];
        [self performSegueWithIdentifier:@"openBands" sender:nil];
    } else {
        [[TrackingManager sharedManager] trackFilterSelectsPlaceView];
        [self performSegueWithIdentifier:@"showLocation" sender:nil];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"openBands"]) {
        FilterBandsViewController *bandsTableViewController = (FilterBandsViewController*)segue.destinationViewController;
        bandsTableViewController.allBandsArray = [self.allBandsArray copy];
    }
}

#pragma mark - view methods
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Filter";

    [self setupTableView];
    self.tableView.estimatedRowHeight = 70.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}

- (void)setupTableView
{
    self.applyButton.titleLabel.font = [UIFont latoRegularFontWithSize:17.0];

    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
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

    [self.searchField addTarget:self
                         action:@selector(searchFieldTextChanged:)
               forControlEvents:UIControlEventEditingChanged];

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
}

@end

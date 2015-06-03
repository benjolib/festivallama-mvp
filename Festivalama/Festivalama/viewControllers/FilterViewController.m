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
#import "FilterGenresViewController.h"
#import "FilterBandsViewController.h"

@interface FilterViewController ()
@property (nonatomic, strong) GenreDownloadClient *genreDownloadClient;
@property (nonatomic, strong, readwrite) NSArray *genresArray;
@end

@implementation FilterViewController

- (IBAction)applyButtonPressed:(id)sender
{
    // TODO:
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)trashButtonPressed:(id)sender
{
    [self.filterModel clearFilters];
}

- (void)downloadGenres
{
    self.genreDownloadClient = [GenreDownloadClient new];

    __weak typeof(self) weakSelf = self;
    [self.genreDownloadClient downloadAllGenresWithCompletionBlock:^(NSArray *sortedGenres, NSString *errorMessage, BOOL completed) {
        if (completed) {
            weakSelf.genresArray = [sortedGenres copy];
        } else {

        }
    }];
}

- (void)setTrashIconVisible:(BOOL)visible
{
    self.trashIcon.hidden = !visible;
}

#pragma mark - tableView methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 1) {
        FilterBandsTableViewCell *cell = (FilterBandsTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"bandsCell"];

        NSString *bandsString = [[FilterModel sharedModel] bandsString];
        if (bandsString.length > 0) {
            UIImageView *accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"trashIcon"]];
            cell.accessoryView = accessoryView;
            cell.backgroundColor = [UIColor clearColor];
        } else {
            UIImageView *accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"disclosureIcon"]];
            cell.accessoryView = accessoryView;
        }

        cell.nameLabel.text = @"Nach Künstlern";
        cell.bandDetailLabel.text = bandsString;
        return cell;
    } else {
        FilterTableViewCell *cell = (FilterTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"basicCell"];

        UIImageView *accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"disclosureIcon"]];
        cell.accessoryView = accessoryView;

        if (indexPath.row == 0) {
            cell.textLabel.text = @"Nach Musik Genre";
        } else {
            cell.textLabel.text = @"Nach Ort";
        }
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        [self performSegueWithIdentifier:@"openGenres" sender:nil];
    } else if (indexPath.row == 1) {
        [self performSegueWithIdentifier:@"openBands" sender:nil];
    } else {
        [self performSegueWithIdentifier:@"showLocation" sender:nil];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"openGenres"]) {
        FilterGenresViewController *genresViewController = (FilterGenresViewController*)segue.destinationViewController;
        genresViewController.allGenresArray = [self.genresArray copy];
    }
}

#pragma mark - view methods
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Filter";

    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self downloadGenres];
    [self setTrashIconVisible:[[FilterModel sharedModel] isFiltering]];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

@end

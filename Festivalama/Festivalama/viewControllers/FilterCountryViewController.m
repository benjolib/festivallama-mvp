//
//  FilterCountryViewController.m
//  Festivalama
//
//  Created by Sztanyi Szabolcs on 01/06/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#import "FilterCountryViewController.h"
#import "FilterCountriesDatasource.h"
#import "FilterTableViewCell.h"
#import "Country.h"
#import "TrackingManager.h"

@interface FilterCountryViewController ()
@property (nonatomic, strong) FilterCountriesDatasource *countriesDatasource;
@property (nonatomic, strong) NSMutableArray *selectedCountriesArray;
@property (nonatomic, strong) NSArray *allCountriesArray;
@end

@implementation FilterCountryViewController

- (void)trashButtonPressed:(id)sender
{
    [[TrackingManager sharedManager] trackFilterTapsTrashIconDetail];
    [FilterModel sharedModel].selectedCountriesArray = nil;
    [self.selectedCountriesArray removeAllObjects];
    [self adjustButtonToFilterModel];
    [self.tableView reloadData];
}

- (void)setupDatasource
{
    if (!self.countriesDatasource) {
        self.countriesDatasource = [[FilterCountriesDatasource alloc] init];
    }
    self.allCountriesArray = [self.countriesDatasource allCountries];

    if (!self.selectedCountriesArray) {
        self.selectedCountriesArray = [NSMutableArray array];
    }
    
    if ([[FilterModel sharedModel] selectedCountriesArray].count > 0) {
        [self.selectedCountriesArray addObjectsFromArray:[[FilterModel sharedModel] selectedCountriesArray]];
    }
    [self.tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.allCountriesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FilterTableViewCell *cell = (FilterTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[FilterTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }

    Country *country = self.allCountriesArray[indexPath.row];

    cell.textLabel.text = country.name;
    cell.imageView.image = [UIImage imageNamed:country.flag];

    if ([self.selectedCountriesArray containsObject:country]) {
        UIImageView *accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"checkMarkIcon"]];
        cell.accessoryView = accessoryView;
        cell.textLabel.textColor = [UIColor whiteColor];
    } else {
        cell.accessoryView = nil;
        cell.textLabel.textColor = [UIColor colorWithWhite:1.0 alpha:0.5];
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (!self.selectedCountriesArray) {
        self.selectedCountriesArray = [NSMutableArray array];
    }

    Country *selectedCountry = self.allCountriesArray[indexPath.row];

    if ([self.selectedCountriesArray containsObject:selectedCountry])
    {
        [[TrackingManager sharedManager] trackFilterSelectsCountryAgainToUnselect];
        [self.selectedCountriesArray removeObject:selectedCountry];
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    else
    {
        [[TrackingManager sharedManager] trackFilterSelectsCountry];
        [self.selectedCountriesArray addObject:selectedCountry];
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }

    [FilterModel sharedModel].selectedCountriesArray = [self.selectedCountriesArray copy];
    [super adjustButtonToFilterModel];
}

#pragma mark - view methods
- (void)viewDidLoad
{
    [super addGradientBackground];
    [super setupTableView];
    self.title = @"Ganz Europa";

    [self setupDatasource];
    [self.tableView reloadData];
    [self.tableView hideLoadingIndicator];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self adjustButtonToFilterModel];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end

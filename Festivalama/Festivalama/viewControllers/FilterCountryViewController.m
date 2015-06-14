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

@interface FilterCountryViewController ()
@property (nonatomic, strong) FilterCountriesDatasource *countriesDatasource;
@property (nonatomic, strong) NSMutableArray *selectedCountriesArray;
@property (nonatomic, strong) NSArray *allCountriesArray;
@end

@implementation FilterCountryViewController

- (void)trashButtonPressed:(id)sender
{
    [self.selectedCountriesArray removeAllObjects];
    [self.tableView reloadData];
}

- (void)setupDatasource
{
    if (!self.countriesDatasource) {
        self.countriesDatasource = [FilterCountriesDatasource new];
    }
    self.allCountriesArray = [self.countriesDatasource countryNames];

    if (!self.selectedCountriesArray) {
        self.selectedCountriesArray = [NSMutableArray array];
    }
    if ([[FilterModel sharedModel] selectedCountry]) {
        [self.selectedCountriesArray addObject:[[FilterModel sharedModel] selectedCountry]];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.allCountriesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FilterTableViewCell *cell = (FilterTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"cell"];

    NSString *countryName = [self.countriesDatasource countryNameAtIndex:indexPath.row];

    cell.textLabel.text = countryName;
    cell.imageView.image = [self.countriesDatasource flagIconAtIndex:indexPath.row];

    if (cell.selected || [self.selectedCountriesArray containsObject:countryName]) {
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
    NSString *selectedCountry = self.allCountriesArray[indexPath.row];
    if ([self.selectedCountriesArray containsObject:selectedCountry]) {
        [self.selectedCountriesArray removeObject:selectedCountry];
        [FilterModel sharedModel].selectedCountry = nil;
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else {
        if (self.selectedCountriesArray.count == 0) {
            [self.selectedCountriesArray addObject:selectedCountry];
            [FilterModel sharedModel].selectedCountry = selectedCountry;
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
    }

    [self adjustButtonToFilterModel];
}

#pragma mark - view methods
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Land";

    [self setupDatasource];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end

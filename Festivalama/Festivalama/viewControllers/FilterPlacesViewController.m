//
//  FilterPlacesViewController.m
//  Festivalama
//
//  Created by Sztanyi Szabolcs on 31/05/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#import "FilterPlacesViewController.h"
#import "FilterTableViewCell.h"

@implementation FilterPlacesViewController

- (void)trashButtonPressed:(id)sender
{
    [FilterModel sharedModel].selectedPostCode = nil;
    [FilterModel sharedModel].selectedCountry = nil;
    [super setFilteringEnabled:NO];
}

#pragma mark - tableView methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FilterTableViewCell *cell = (FilterTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"cell"];

    UIImageView *accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"disclosureIcon"]];
    cell.accessoryView = accessoryView;

    if (indexPath.row == 0) {
        cell.textLabel.text = @"Postleitzahl";
        return cell;
    } else {
        cell.textLabel.text = @"Land";
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        [self performSegueWithIdentifier:@"openPostcode" sender:nil];
    } else {
        [self performSegueWithIdentifier:@"openCountry" sender:nil];
    }
}

#pragma mark - view methods
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Ort";

    if (FilterModel.sharedModel.selectedCountry || FilterModel.sharedModel.selectedPostCode) {
        [self setTrashIconVisible:YES];
    } else {
        [self setTrashIconVisible:NO];
    }
    [self.tableView hideLoadingIndicator];
}

@end

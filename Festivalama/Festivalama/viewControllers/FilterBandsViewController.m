//
//  FilterBandsViewController.m
//  Festivalama
//
//  Created by Sztanyi Szabolcs on 02/06/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#import "FilterBandsViewController.h"
#import "BandsDownloadClient.h"
#import "Band.h"
#import "FilterTableViewCell.h"

@interface FilterBandsViewController ()
@property (nonatomic, strong) BandsDownloadClient *bandsDownloadClient;
@property (nonatomic, strong) NSArray *allBandsArray;
@property (nonatomic, strong) NSMutableArray *selectedBandsArray;
@end

@implementation FilterBandsViewController

- (void)trashButtonPressed:(id)sender
{
    [self.selectedBandsArray removeAllObjects];
    [self.tableView reloadData];
    [FilterModel sharedModel].selectedBandsArray = nil;
}

- (NSMutableArray *)selectedBandsArray
{
//    [self setTrashIconVisible:_selectedBandsArray.count > 0];
    [[FilterModel sharedModel] setSelectedBandsArray:[NSArray arrayWithArray:_selectedBandsArray]];
    return _selectedBandsArray;
}

#pragma mark - view methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.allBandsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FilterTableViewCell *cell = (FilterTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"cell"];

    Band *band = self.allBandsArray[indexPath.row];
    cell.textLabel.text = band.name;

    if ([self.selectedBandsArray containsObject:self.allBandsArray[indexPath.row]]) {
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
    if (!self.selectedBandsArray) {
        self.selectedBandsArray = [NSMutableArray array];
    }

    Band *selectedBand = self.allBandsArray[indexPath.row];
    if ([self.selectedBandsArray containsObject:selectedBand]) {
        [self.selectedBandsArray removeObject:selectedBand];
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else {
        [self.selectedBandsArray addObject:selectedBand];
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }

    [self adjustButtonToFilterModel];
}

#pragma mark - view methods
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Bands";
    
    [self downloadBands];
}

- (void)downloadBands
{
    self.bandsDownloadClient = [BandsDownloadClient new];

    __weak typeof(self) weakSelf = self;
    [self.bandsDownloadClient downloadAllBandsWithCompletionBlock:^(NSArray *sortedBands, NSString *errorMessage, BOOL completed) {
        if (completed) {
            weakSelf.allBandsArray = [sortedBands copy];
            weakSelf.selectedBandsArray = [[[FilterModel sharedModel] selectedBandsArray] mutableCopy];
            [weakSelf.tableView reloadData];
        } else {

        }
    }];
}

- (void)dealloc
{
    self.bandsDownloadClient = nil;
}

@end

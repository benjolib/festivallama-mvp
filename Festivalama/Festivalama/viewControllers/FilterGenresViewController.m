//
//  FilterGenresViewController.m
//  Festivalama
//
//  Created by Sztanyi Szabolcs on 01/06/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#import "FilterGenresViewController.h"
#import "FilterTableViewCell.h"
#import "Genre.h"

@interface FilterGenresViewController ()
@property (nonatomic, strong) NSMutableArray *selectedGenresArray;
@end

@implementation FilterGenresViewController

- (void)trashButtonPressed:(id)sender
{
    [self.selectedGenresArray removeAllObjects];
    [self.tableView reloadData];
}

- (NSMutableArray *)selectedGenresArray
{
    [self setTrashIconVisible:_selectedGenresArray.count > 0];
    [FilterModel sharedModel].selectedGenresArray = [_selectedGenresArray copy];
    return _selectedGenresArray;
}

#pragma mark - tableView methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.allGenresArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FilterTableViewCell *cell = (FilterTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"cell"];

    Genre *genre = self.allGenresArray[indexPath.row];
    cell.textLabel.text = genre.name;

    if ([self.selectedGenresArray containsObject:self.allGenresArray[indexPath.row]]) {
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
    if (!self.selectedGenresArray) {
        self.selectedGenresArray = [NSMutableArray array];
    }

    Genre *selectedGenre = self.allGenresArray[indexPath.row];
    if ([self.selectedGenresArray containsObject:selectedGenre]) {
        [self.selectedGenresArray removeObject:selectedGenre];
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else {
        [self.selectedGenresArray addObject:selectedGenre];
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }

    [self adjustButtonToFilterModel];
}

#pragma mark - view methods
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Musik Genres";

    self.selectedGenresArray = [[[FilterModel sharedModel] selectedGenresArray] mutableCopy];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end

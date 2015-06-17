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
@property (nonatomic, strong) NSArray *allGenresArrayCopy;
@property (nonatomic, strong) NSArray *tableData;
@property (nonatomic, strong) NSArray *sectionIndexTitles;
@property (nonatomic, strong) NSMutableArray *selectedGenresArray;
@end

@implementation FilterGenresViewController

- (void)trashButtonPressed:(id)sender
{
    [FilterModel sharedModel].selectedGenresArray = nil;
    [self.selectedGenresArray removeAllObjects];
    [self.tableView reloadData];

    [super adjustButtonToFilterModel];
}

- (NSArray*)sectionIndexTitles
{
    if (_sectionIndexTitles) {
        return _sectionIndexTitles;
    }
    NSMutableArray *firstLetterArray = [NSMutableArray array];
    for (Genre *genre in self.allGenresArray) {
        NSString *genreName = genre.name;

        if (genreName.length >= 1) {
            NSString *firstLetter = [genreName substringToIndex:1];
            if (![firstLetterArray containsObject:firstLetter]) {
                [firstLetterArray addObject:firstLetter];
            }
        }
    }
    _sectionIndexTitles = firstLetterArray;
    return _sectionIndexTitles;
}

#pragma mark - search methods
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.searchWrapperViewTrailingConstraint.constant = 10.0;
    self.searchCancelButtonWidthConstraint.constant = 70.0;
    [UIView animateWithDuration:0.2 animations:^{
        [self.searchWrapperView layoutIfNeeded];
    }];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.text.length == 0) {
        [self hideSearchCancelButton];
    }
}

- (void)searchFieldTextChanged:(UITextField*)textfield
{
    dispatch_async(dispatch_queue_create("com.festivalama.bandQueue", NULL), ^{
        if (textfield.text.length > 0) {
            _sectionIndexTitles = nil;
            self.allGenresArray = [self.allGenresArrayCopy filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"name contains[cd] %@", textfield.text]];
            self.tableData = [self partitionObjects:self.allGenresArray collationStringSelector:@selector(name)];
        } else {
            _sectionIndexTitles = nil;
            self.tableData = [self partitionObjects:self.allGenresArrayCopy collationStringSelector:@selector(name)];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    });
}

- (IBAction)searchCancelButtonTapped:(id)sender
{
    [self.view endEditing:YES];
    [self hideSearchCancelButton];

    self.searchField.text = @"";
    dispatch_async(dispatch_queue_create("com.festivalama.genreQueue", NULL), ^{
        _sectionIndexTitles = nil;
        self.allGenresArray = [self.allGenresArrayCopy copy];
        self.tableData = [self partitionObjects:self.allGenresArrayCopy collationStringSelector:@selector(name)];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    });
}

- (void)hideSearchCancelButton
{
    self.searchWrapperViewTrailingConstraint.constant = 0.0;
    self.searchCancelButtonWidthConstraint.constant = 0.0;
    [UIView animateWithDuration:0.2 animations:^{
        [self.searchWrapperView layoutIfNeeded];
    }];
}

#pragma mark - tableView methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[[UILocalizedIndexedCollation currentCollation] sectionTitles] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.tableData objectAtIndex:section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FilterTableViewCell *cell = (FilterTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"cell"];

    Genre *genre = self.tableData[indexPath.section][indexPath.row];
    cell.textLabel.text = genre.name;

    if ([self.selectedGenresArray containsObject:genre]) {
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

    Genre *selectedGenre = self.tableData[indexPath.section][indexPath.row];
    if ([self.selectedGenresArray containsObject:selectedGenre]) {
        [self.selectedGenresArray removeObject:selectedGenre];
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else {
        [self.selectedGenresArray addObject:selectedGenre];
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }

    [[FilterModel sharedModel] setSelectedGenresArray:[self.selectedGenresArray copy]];
    [self adjustButtonToFilterModel];
}

#pragma mark - section index titles
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    //sectionForSectionIndexTitleAtIndex: is a bit buggy, but is still useable
    return [[UILocalizedIndexedCollation currentCollation] sectionForSectionIndexTitleAtIndex:index];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return [[UILocalizedIndexedCollation currentCollation] sectionIndexTitles];
}

- (NSArray *)partitionObjects:(NSArray *)array collationStringSelector:(SEL)selector
{
    UILocalizedIndexedCollation *collation = [UILocalizedIndexedCollation currentCollation];
    NSInteger sectionCount = [[collation sectionTitles] count]; //section count is take from sectionTitles and not sectionIndexTitles
    NSMutableArray *unsortedSections = [NSMutableArray arrayWithCapacity:sectionCount];
    //create an array to hold the data for each section
    for(int i = 0; i < sectionCount; i++) {
        [unsortedSections addObject:[NSMutableArray array]];
    }
    //put each object into a section
    for (id object in array) {
        NSInteger index = [collation sectionForObject:object collationStringSelector:selector];
        [[unsortedSections objectAtIndex:index] addObject:object];
    }
    NSMutableArray *sections = [NSMutableArray arrayWithCapacity:sectionCount];
    //sort each section
    for (NSMutableArray *section in unsortedSections) {
        [sections addObject:[collation sortedArrayFromArray:section collationStringSelector:selector]];
    }
    return sections;
}

#pragma mark - view methods
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Musik Genres";

    [self setupSearchView];
    self.allGenresArrayCopy = [self.allGenresArray copy];
    self.selectedGenresArray = [[[FilterModel sharedModel] selectedGenresArray] mutableCopy];
    self.tableData = [self partitionObjects:self.allGenresArrayCopy collationStringSelector:@selector(name)];
    [self.tableView reloadData];
    [self.tableView hideLoadingIndicator];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end

//
//  FilterPostcodeViewController.m
//  Festivalama
//
//  Created by Sztanyi Szabolcs on 01/06/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#import "FilterPostcodeViewController.h"
#import "FilterTableViewCell.h"
#import "TrackingManager.h"
#import "FilterPostcode.h"

@interface FilterPostcodeViewController ()
@property (nonatomic, strong) NSMutableArray *allPostcodesArray;
@property (nonatomic, strong) NSMutableArray *selectedPostCodesArray;
@end

@implementation FilterPostcodeViewController

- (void)trashButtonPressed:(id)sender
{
    [[TrackingManager sharedManager] trackFilterTapsTrashIconDetail];
    [FilterModel sharedModel].selectedPostCode = nil;
    [self.selectedPostCodesArray removeAllObjects];
    [self.tableView reloadData];

    [super adjustButtonToFilterModel];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.allPostcodesArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FilterTableViewCell *cell = (FilterTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    FilterPostcode *postcode = self.allPostcodesArray[indexPath.row];
    cell.textLabel.text = postcode.title;

    if ([self.selectedPostCodesArray containsObject:self.allPostcodesArray[indexPath.row]]) {
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
    [[TrackingManager sharedManager] trackFilterSelectsPostcode];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (!self.selectedPostCodesArray) {
        self.selectedPostCodesArray = [NSMutableArray array];
    }
    
    FilterPostcode *selectedPostcode = self.allPostcodesArray[indexPath.row];
    if ([self.selectedPostCodesArray containsObject:selectedPostcode]) {
        [self.selectedPostCodesArray removeObject:selectedPostcode];
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [FilterModel sharedModel].selectedPostCode = nil;
    } else {
        if (self.selectedPostCodesArray.count != 0) {
            NSInteger selectedCountryIndex = [self.allPostcodesArray indexOfObject:self.selectedPostCodesArray.firstObject];
            NSIndexPath *selectedIndexPath = [NSIndexPath indexPathForRow:selectedCountryIndex inSection:0];
            [self.selectedPostCodesArray removeAllObjects];
            if (selectedIndexPath) {
                [tableView reloadRowsAtIndexPaths:@[selectedIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            }
        }
        [self.selectedPostCodesArray addObject:selectedPostcode];
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [FilterModel sharedModel].selectedPostCode = selectedPostcode;
    }

    [super adjustButtonToFilterModel];
}

#pragma mark - view methods
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Innerhalb Deutschlands";

    [self.tableView reloadData];
    [self.tableView hideLoadingIndicator];

    [self populateArrayWithPostcodes];
    
    if (!self.selectedPostCodesArray) {
        self.selectedPostCodesArray = [NSMutableArray array];
    }
    if ([[FilterModel sharedModel] selectedPostCode]) {
        [self.selectedPostCodesArray addObject:[[FilterModel sharedModel] selectedPostCode]];
    }
}

- (void)populateArrayWithPostcodes
{
    if (!self.allPostcodesArray) {
        self.allPostcodesArray = [NSMutableArray array];
    }
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Postcodes" ofType:@"plist"];
    NSArray *postcodesArray = [[NSArray alloc] initWithContentsOfFile:filePath];
    
    for (NSDictionary *postcodeDictionary in postcodesArray) {
        FilterPostcode *postcode = [FilterPostcode filterPostcodeWithTitle:postcodeDictionary[@"title"]
                                                                  andValue:[postcodeDictionary[@"value"] integerValue]];
        [self.allPostcodesArray addObject:postcode];
    }
    
    [self.tableView reloadData];
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

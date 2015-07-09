//
//  CalendarViewController.m
//  Festivalama
//
//  Created by Sztanyi Szabolcs on 07/06/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#import "CalendarViewController.h"
#import "CoreDataHandler.h"
#import "LoadingTableView.h"
#import "FestivalTableViewCell.h"
#import "TableviewCounterView.h"
#import "CDFestival+CDFestivalHelper.h"
#import "FestivalModel.h"
#import "FestivalDetailViewController.h"
#import "UIFont+LatoFonts.h"
#import "TrackingManager.h"

@interface CalendarViewController () <NSFetchedResultsControllerDelegate>
@property (nonatomic, strong) NSArray *savedFestivalsArray;
@property (nonatomic, strong) NSFetchedResultsController *fetchController;
@end

@implementation CalendarViewController

- (NSFetchedResultsController *)fetchController
{
    if (_fetchController) {
        return _fetchController;
    }
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"CDFestival"];
    [fetchRequest setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"startDate" ascending:YES]]];

    [fetchRequest setFetchLimit:20];
    fetchRequest.includesSubentities = YES;

    _fetchController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                           managedObjectContext:[[CoreDataHandler sharedHandler] mainManagedObjectContext]
                                                             sectionNameKeyPath:@"sectionTitle"
                                                                      cacheName:nil];
    _fetchController.delegate = self;
    return _fetchController;
}

- (void)fetchAllFestivals
{
    NSError *fetchError = nil;
    if (![self.fetchController performFetch:&fetchError]) {
        NSLog(@"Error occured during fetching projects: %@", fetchError.localizedDescription);
    }

    [self updateTableCounterView];
    [self.tableView hideLoadingIndicator];
    [self.tableView reloadData];
}

- (void)updateTableCounterView
{
    NSInteger numberOfItems = self.fetchController.fetchedObjects.count;
    [self.tableCounterView displayTheNumberOfItems:(numberOfItems == 0 ? 0 : numberOfItems)];

    if (numberOfItems != 0 && self.isSearching) {
        [self.tableCounterView setCounterViewVisible:YES animated:YES];
    } else {
        [self.tableCounterView setCounterViewVisible:NO animated:YES];
    }

    if (self.fetchController.fetchedObjects.count == 0 && !self.isSearching) {
        [self.tableView showEmptyCalendarView];
    } else {
        [self.tableView hideEmptyView];
    }
}

#pragma mark - fetchController delegate methods
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.tableView;
    switch(type)
    {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationLeft];
            break;
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
            break;
        case NSFetchedResultsChangeUpdate:
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    UITableView *tableView = self.tableView;
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:sectionIndex];
    switch(type)
    {
        case NSFetchedResultsChangeInsert:
            [tableView insertSections:indexSet withRowAnimation:UITableViewRowAnimationLeft];
            break;
        case NSFetchedResultsChangeDelete:
            [tableView deleteSections:indexSet withRowAnimation:UITableViewRowAnimationRight];
            break;
        case NSFetchedResultsChangeUpdate:
            [tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        case NSFetchedResultsChangeMove:
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
    [self updateTableCounterView];
}

#pragma mark - tableView methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchController.sections objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.fetchController.sections.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30.0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchController.sections objectAtIndex:section];
    return [sectionInfo name];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, CGRectGetWidth(tableView.frame), 30.0)];
    headerView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.2];

    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.0, 0.0, CGRectGetWidth(tableView.frame) - 30.0, 30.0)];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = [tableView.dataSource tableView:tableView titleForHeaderInSection:section];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.font = [UIFont latoBoldFontWithSize:17.0];
    [headerView addSubview:titleLabel];

    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FestivalTableViewCell *cell = (FestivalTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"cell"];
    CDFestival *savedFestival = [self.fetchController objectAtIndexPath:indexPath];

    FestivalModel *festival = [savedFestival festivalModel];

    cell.nameLabel.text = festival.name;
    cell.locationLabel.text = [festival locationAddress];
    NSString *timeString = [festival calendarDaysTillStartDateString];
    cell.timeLeftLabel.text = timeString;
    cell.calendarIcon.hidden = timeString.length == 0;

    [cell showSavedState:YES];

    [cell.calendarButton addTarget:self action:@selector(calenderButtonTapped:) forControlEvents:UIControlEventTouchUpInside];

    return cell;
}

- (void)calenderButtonTapped:(UIButton*)button
{
    UIView *aSuperview = [button superview];
    while (![aSuperview isKindOfClass:[FestivalTableViewCell class]]) {
        aSuperview = [aSuperview superview];
    }

    FestivalTableViewCell *cell = (FestivalTableViewCell*)aSuperview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    CDFestival *festival = [self.fetchController objectAtIndexPath:indexPath];

    [[TrackingManager sharedManager] trackUserRemovesFestivalFromCalendar];
    [[CoreDataHandler sharedHandler] removeFestivalObject:festival];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [self performSegueWithIdentifier:@"openFestivalDetailView" sender:cell];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([sender isKindOfClass:[UITableViewCell class]] && [segue.identifier isEqualToString:@"openFestivalDetailView"]) {
        UITableViewCell *cell = (UITableViewCell*)sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];

        CDFestival *savedFestival = [self.fetchController objectAtIndexPath:indexPath];
        FestivalModel *festival = [savedFestival festivalModel];

        FestivalDetailViewController *detailViewController = (FestivalDetailViewController*)segue.destinationViewController;
        detailViewController.festivalToDisplay = festival;
    }
}

- (void)downloadNextFestivals
{}

#pragma mark - searching
- (void)searchNavigationViewSearchButtonPressed:(NSString *)searchText
{
    [self searchWithText:searchText];
}

- (void)searchNavigationViewUserEnteredNewCharacter:(NSString *)searchText
{
    [self searchWithText:searchText];
}

- (void)searchNavigationViewCancelButtonPressed
{
    [self.tableView hideEmptyView];

    [self.fetchController.fetchRequest setPredicate:nil];
    [self fetchAllFestivals];
}

- (void)searchWithText:(NSString*)searchText
{
    if (searchText.length > 0) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name contains[cd] %@", searchText];
        [self.fetchController.fetchRequest setPredicate:predicate];
        self.isSearching = YES;
    } else {
        [self.fetchController.fetchRequest setPredicate:nil];
        self.isSearching = NO;
    }

    [self fetchAllFestivals];

    if (self.fetchController.fetchedObjects.count == 0) {
        [self.tableView showEmptySearchView];
    } else {
        [self.tableView hideEmptyView];
    }
}

#pragma mark - view methods
- (void)viewDidLoad
{
    [self addGradientBackground];
    [self.tableView registerNib:[UINib nibWithNibName:@"FestivalTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"cell"];

    self.tableCounterView = [[TableviewCounterView alloc] initWithFrame:CGRectZero];
    [self.tableCounterView addToView:self.view];
    [self loadAllSavedFestivals];
}

- (void)loadAllSavedFestivals
{
    [self fetchAllFestivals];
}

@end

//
//  MenuViewController.m
//  Festivalama
//
//  Created by Sztanyi Szabolcs on 31/05/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#import "MenuViewController.h"
#import "MenuButton.h"
#import "FestivalsViewController.h"
#import "FestivalTransitionManager.h"
#import "FestivalNavigationController.h"
#import "PopularFestivalsViewController.h"
#import "MainContainerViewController.h"

@interface MenuViewController ()
@property (nonatomic, strong) UITapGestureRecognizer *tapRecognizer;
@property (nonatomic, weak) UIViewController *sourceViewController;
@property (nonatomic, strong) FestivalTransitionManager *transitionManager;
@end

@implementation MenuViewController

- (void)updateCalendarButton
{

}

- (void)saveSourceViewController:(UIViewController*)sourceViewController
{
    self.sourceViewController = sourceViewController;
}

- (MainContainerViewController*)mainContainerViewController
{
    if ([self.sourceViewController.parentViewController isKindOfClass:[MainContainerViewController class]]) {
        return (MainContainerViewController*)self.sourceViewController.parentViewController;
    }
    return nil;
}

- (IBAction)festivalButtonPressed:(id)sender
{
    if ([self.sourceViewController isKindOfClass:[FestivalsViewController class]] && ![self.sourceViewController isKindOfClass:[PopularFestivalsViewController class]]) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self switchCurrentSourceWithMenuItem:MenuItemFestivals];
    }
}

- (IBAction)favoriteButtonPressed:(id)sender
{
    if ([self.sourceViewController isKindOfClass:[PopularFestivalsViewController class]]) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self switchCurrentSourceWithMenuItem:MenuItemFavoriteFestivals];
    }
}

- (IBAction)calendarButtonPressed:(id)sender
{
//    if ([self.sourceViewController isKindOfClass:[PopularFestivalsViewController class]]) {
//        [self dismissViewControllerAnimated:YES completion:nil];
//    } else {
//        [self switchCurrentSourceControllerTo:[PopularFestivalsViewController class]];
//    }
}

- (void)switchCurrentSourceWithMenuItem:(MenuItem)menuItem
{
    MainContainerViewController *mainContainerViewController = [self mainContainerViewController];
    if (!mainContainerViewController) {
        return;
    }

    [mainContainerViewController changeToMenuItem:menuItem];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"openInfoView"]) {
        self.transitionManager = [[FestivalTransitionManager alloc] init];
        FestivalNavigationController *destinationViewController = segue.destinationViewController;
        destinationViewController.transitioningDelegate = self.transitionManager;
    }
}

#pragma mark - tapRecognizer
- (void)addRecognizer
{
    self.tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    self.tapRecognizer.numberOfTapsRequired = 1.0;
    [self.view addGestureRecognizer:self.tapRecognizer];
}

- (void)viewTapped:(UITapGestureRecognizer*)taprecognizer
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - view methods
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self updateCalendarButton];
    [self addRecognizer];

    [self.calendarButton setBadgeCounterValue:99];

    if ([self.sourceViewController isKindOfClass:[FestivalsViewController class]] && ![self.sourceViewController isKindOfClass:[PopularFestivalsViewController class]]) {
        [UIView animateWithDuration:0.2 animations:^{
            [self.festivalButton setActive:YES];
            [self.favoriteFestivalButton setActive:NO];
            [self.calendarButton setActive:NO];
        }];
    } else if ([self.sourceViewController isKindOfClass:[PopularFestivalsViewController class]]) {
        [UIView animateWithDuration:0.2 animations:^{
            [self.festivalButton setActive:NO];
            [self.favoriteFestivalButton setActive:YES];
            [self.calendarButton setActive:NO];
        }];
    } else {

    }
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

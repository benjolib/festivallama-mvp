//
//  MainContainerViewController.m
//  Festivalama
//
//  Created by Sztanyi Szabolcs on 05/06/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#import "MainContainerViewController.h"
#import "FestivalsViewController.h"
#import "PopularFestivalsViewController.h"
#import "StoryboardManager.h"
#import "MenuTransitionManager.h"
#import "MenuViewController.h"
#import "UIColor+AppColors.h"
#import "TutorialPopupView.h"
#import "GeneralSettings.h"
#import "CalendarViewController.h"
#import "SearchNavigationView.h"
#import "BaseGradientViewController.h"

@interface MainContainerViewController ()
@property (nonatomic, strong) BaseGradientViewController *mainViewController;
@property (nonatomic, strong) MenuTransitionManager *menuTransitionManager;
@property (nonatomic) MenuItem currentMenuItem;
@property (nonatomic, strong) SearchNavigationView *searchView;
@end

@implementation MainContainerViewController

- (void)setParentTitle:(NSString*)title
{
    [self.searchView setTitle:title];
}

- (void)changeToMenuItem:(MenuItem)menuItem
{
    switch (menuItem)
    {
        case MenuItemFestivals: {
            FestivalsViewController *festivalsViewController = [StoryboardManager festivalsViewController];
            [self startTransitionToViewController:festivalsViewController];
            self.currentMenuItem = MenuItemFestivals;
            [self setParentTitle:@"Festivals"];
            break;
        }
        case MenuItemFavoriteFestivals: {
            PopularFestivalsViewController *popularFestivalsViewController = [StoryboardManager popularFestivalsViewController];
            [self startTransitionToViewController:popularFestivalsViewController];
            self.currentMenuItem = MenuItemFavoriteFestivals;
            [self setParentTitle:@"Beliebte Festivals"];
            break;
        }
        case MenuItemFestivalsCalendar: {
            CalendarViewController *calendarViewController = [StoryboardManager calendarViewController];
            [self startTransitionToViewController:calendarViewController];
            self.currentMenuItem = MenuItemFestivalsCalendar;
            [self setParentTitle:@"Kalender"];
            break;
        }
        default:
            break;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSString *segueID = segue.identifier;
    if ([segueID isEqualToString:@"embedView"])
    {
        BaseGradientViewController *controller = (BaseGradientViewController*)[segue destinationViewController];
        self.mainViewController = controller;
        self.searchView.delegate = self.mainViewController;
        self.currentMenuItem = MenuItemFestivals;
        [self setParentTitle:@"Festivals"];
    }
    else if ([segueID isEqualToString:@"presentMenuView"])
    {
        MenuViewController *menuVC = (MenuViewController*)segue.destinationViewController;
        if (!self.menuTransitionManager) {
            self.menuTransitionManager = [[MenuTransitionManager alloc] init];
        }
        menuVC.transitioningDelegate = self.menuTransitionManager;
        [menuVC saveSourceViewController:self.mainViewController];
    }
}

- (void)startTransitionToViewController:(BaseGradientViewController*)toDisplayViewController
{
    [self addChildViewController:toDisplayViewController];

    [self transitionFromViewController:self.mainViewController
                      toViewController:toDisplayViewController
                              duration:0.0
                               options:UIViewAnimationOptionTransitionCrossDissolve
                            animations:^{
                                toDisplayViewController.view.frame = self.containerView.bounds;
                            }
                            completion:^(BOOL finished) {
                                [self.mainViewController willMoveToParentViewController:nil];
                                [self.mainViewController removeFromParentViewController];

                                [toDisplayViewController didMoveToParentViewController:self];
                                self.mainViewController = toDisplayViewController;
                                self.searchView.delegate = self.mainViewController;
                            }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showTutorialPopups) name:kNotificationTutorialDismissed object:nil];

    [self setupSearchView];
}

- (void)setupSearchView
{
    self.searchView = [[SearchNavigationView alloc] initWithTitle:@"Festivals" andDelegate:self.mainViewController];
    self.searchView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.navigationView addSubview:self.searchView];

    [self.navigationView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_searchView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_searchView)]];
    [self.navigationView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_searchView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_searchView)]];

    [self.searchView assignLeftButtonWithSelector:@selector(leftNavigationButtonPressed) toTarget:self];
}

- (void)leftNavigationButtonPressed
{
    [self performSegueWithIdentifier:@"presentMenuView" sender:nil];
}

- (void)searchNavigationViewMenuButtonPressed
{
    [self performSegueWithIdentifier:@"presentMenuView" sender:nil];
}

- (void)showTutorialPopups
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        TutorialPopupView *tutorial = [[TutorialPopupView alloc] init];
        [tutorial showWithText:@"Suche nach Festivals, Künstlern, Orten oder Musik Genres"
                       atPoint:CGPointMake(CGRectGetWidth(self.view.frame) - 50.0, CGRectGetMaxY(self.searchView.searchButton.frame) + 20.0)
                 highLightArea:self.navigationView.frame];

        [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationTutorialDismissed object:nil];
        [GeneralSettings setTutorialsShown];
    });
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

@end

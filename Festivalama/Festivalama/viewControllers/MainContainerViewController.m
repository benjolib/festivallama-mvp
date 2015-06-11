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

@interface MainContainerViewController ()
@property (nonatomic, strong) UIViewController *mainViewController;
@property (nonatomic, strong) MenuTransitionManager *menuTransitionManager;
@property (nonatomic) MenuItem currentMenuItem;
@end

@implementation MainContainerViewController

- (void)setParentTitle:(NSString*)title
{
    self.titleLabel.text = title;
}

- (IBAction)leftNavigationButtonPressed:(id)sender
{
    // open menu, can be used in a subclass
}

- (IBAction)rightNavigationButtonPressed:(id)sender
{
    if ([self.mainViewController respondsToSelector:@selector(searchButtonPressed:)]) {
        [self.mainViewController performSelector:@selector(searchButtonPressed:) withObject:nil];
    }
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
        UIViewController *controller = [segue destinationViewController];
        self.mainViewController = controller;
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

- (void)startTransitionToViewController:(UIViewController*)toDisplayViewController
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
                            }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.titleLabel.textColor = [UIColor globalGreenColor];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showTutorialPopups) name:kNotificationTutorialDismissed object:nil];
}

- (void)showTutorialPopups
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        TutorialPopupView *tutorial = [[TutorialPopupView alloc] init];
        [tutorial showWithText:@"Suche nach Festivals, Künstlern, Orten oder Musik Genres"
                       atPoint:CGPointMake(CGRectGetWidth(self.view.frame) - 50.0, CGRectGetMaxY(self.rightButton.frame) + 20.0)
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

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

@interface MenuViewController ()
@property (nonatomic, strong) UITapGestureRecognizer *tapRecognizer;
@property (nonatomic, weak) UIViewController *sourceViewController;
@end

@implementation MenuViewController

- (void)updateCalendarButton
{

}

- (void)saveSourceViewController:(UIViewController*)sourceViewController
{
    self.sourceViewController = sourceViewController;

    if ([sourceViewController isKindOfClass:[FestivalsViewController class]]) {
        [UIView animateWithDuration:0.2 animations:^{
            [self.festivalButton setActive:YES];
            [self.calendarButton setActive:NO];
            [self.favoriteFestivalButton setActive:NO];
        }];
    } else {
        // TODO:
    }
}

- (IBAction)festivalButtonPressed:(id)sender
{

}

- (IBAction)calendarButtonPressed:(id)sender
{

}

- (IBAction)favoriteButtonPressed:(id)sender
{

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

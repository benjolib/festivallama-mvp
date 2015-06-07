//
//  FestivalDetailViewController.m
//  Festivalama
//
//  Created by Sztanyi Szabolcs on 04/06/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#import "FestivalDetailViewController.h"
#import "FestivalModel.h"
#import "UIColor+AppColors.h"
#import "FestivalDetailInfoViewController.h"
#import "FestivalDetailBandsViewController.h"
#import "FestivalDetailLocationViewController.h"
#import "GreenButton.h"
#import "StoryboardManager.h"

@interface FestivalDetailViewController ()
@property (nonatomic, strong) UIViewController *displayViewController;
@end

@implementation FestivalDetailViewController

- (IBAction)ticketShopButtonPressed:(id)sender
{

}

- (IBAction)shareButtonPressed:(id)sender
{

}

- (IBAction)backButtonPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)infoButtonPressed:(id)sender
{
    if ([self.displayViewController isKindOfClass:[FestivalDetailInfoViewController class]]) {
        return;
    } else {
        FestivalDetailInfoViewController *festivalInfoController = [StoryboardManager festivalDetailInfoViewController];
        [self switchCurrentViewControllerTo:festivalInfoController];
        festivalInfoController.festivalToDisplay = self.festivalToDisplay;
    }
}

- (IBAction)bandsButtonPressed:(id)sender
{
    if ([self.displayViewController isKindOfClass:[FestivalDetailBandsViewController class]]) {
        return;
    } else {
        FestivalDetailBandsViewController *festivalBandsController = [StoryboardManager festivalDetailBandsViewController];
        [self switchCurrentViewControllerTo:festivalBandsController];
        festivalBandsController.festivalToDisplay = self.festivalToDisplay;
    }
}

- (IBAction)locationButtonPressed:(id)sender
{
    if ([self.displayViewController isKindOfClass:[FestivalDetailLocationViewController class]]) {
        return;
    } else {
        FestivalDetailLocationViewController *festivalLocationController = [StoryboardManager festivalDetailLocationViewController];
        [self switchCurrentViewControllerTo:festivalLocationController];
//        festivalBandsController.festivalToDisplay = self.festivalToDisplay;
    }
}

- (void)switchCurrentViewControllerTo:(UIViewController*)toViewController
{
    [self addChildViewController:toViewController];

    [self transitionFromViewController:self.displayViewController
                      toViewController:toViewController
                              duration:0.0
                               options:UIViewAnimationOptionTransitionCrossDissolve
                            animations:^{
                                toViewController.view.frame = self.view.bounds;
                            }
                            completion:^(BOOL finished) {
                                [self.displayViewController willMoveToParentViewController:nil];
                                [self.displayViewController removeFromParentViewController];

                                [toViewController didMoveToParentViewController:self];
                                self.displayViewController = toViewController;
                            }];
}

#pragma mark - view methods
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = self.festivalToDisplay.name;

    self.titleLabel.textColor = [UIColor globalGreenColor];
    self.titleLabel.text = self.festivalToDisplay.name;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"embedInfoView"])
    {
        self.displayViewController = segue.destinationViewController;
        if ([self.displayViewController isKindOfClass:[FestivalDetailInfoViewController class]]) {
            FestivalDetailInfoViewController *infoViewController = (FestivalDetailInfoViewController*)self.displayViewController;
            infoViewController.festivalToDisplay = self.festivalToDisplay;
        }
    }
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

@end

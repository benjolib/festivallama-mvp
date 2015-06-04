//
//  FestivalDetailViewController.m
//  Festivalama
//
//  Created by Sztanyi Szabolcs on 04/06/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#import "FestivalDetailViewController.h"
#import "FestivalModel.h"

@interface FestivalDetailViewController ()
@property (nonatomic, strong) UIViewController *displayViewController;
@end

@implementation FestivalDetailViewController

- (IBAction)shareButtonPressed:(id)sender
{

}

- (IBAction)infoButtonPressed:(id)sender
{

}

- (IBAction)bandsButtonPressed:(id)sender
{

}

- (IBAction)locationButtonPressed:(id)sender
{

}

- (void)switchCurrentViewControllerTo:(UIViewController*)toViewController
{
    [self transitionFromViewController:self.displayViewController
                      toViewController:toViewController
                              duration:0.0
                               options:UIViewAnimationOptionTransitionCrossDissolve
                            animations:^{
                                toViewController.view.frame = self.view.bounds;
                            }
                            completion:^(BOOL finished) {
                                [toViewController didMoveToParentViewController:self];
                                self.displayViewController = toViewController;
                            }];
}

- (void)loadViewControllerWithIdentifier:(NSString*)identifier
{

}

#pragma mark - view methods
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = self.festivalToDisplay.name;

    [self loadViewControllerWithIdentifier:@""];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

@end

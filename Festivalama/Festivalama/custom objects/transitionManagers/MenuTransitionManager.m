//
//  MenuTransitionManager.m
//  Festivalama
//
//  Created by Sztanyi Szabolcs on 31/05/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#import "MenuTransitionManager.h"
#import "MenuViewController.h"
#import "StoryboardManager.h"
#import "MenuTransitionAnimator.h"

@interface MenuTransitionManager () <UIViewControllerTransitioningDelegate>

@end

@implementation MenuTransitionManager

- (void)presentMenuViewControllerOnViewController:(UIViewController*)baseController
{
    MenuViewController *menuViewController = [StoryboardManager menuViewController];
    menuViewController.transitioningDelegate = self;
    [baseController presentViewController:menuViewController animated:YES completion:nil];
}

#pragma mark - transitioningDelegate methods
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    MenuTransitionAnimator *animator = [MenuTransitionAnimator new];
    animator.isPresenting = YES;
    return animator;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    MenuTransitionAnimator *animator = [MenuTransitionAnimator new];
    animator.isPresenting = NO;
    return animator;
}

@end

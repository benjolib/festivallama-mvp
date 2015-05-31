//
//  MenuTransitionAnimator.m
//  Festivalama
//
//  Created by Sztanyi Szabolcs on 31/05/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#import "MenuTransitionAnimator.h"
#import "UIImage+ImageEffects.h"

@implementation MenuTransitionAnimator

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.3;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    NSTimeInterval transitonDuration = [self transitionDuration:transitionContext];

    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *containerView = [transitionContext containerView];

    if (self.isPresenting)
    {
        CGRect frame = fromViewController.view.frame;
        UIGraphicsBeginImageContext(frame.size);
        [fromViewController.view drawViewHierarchyInRect:frame afterScreenUpdates:YES];
        UIImage *snapshotImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();

        UIImageView *blurredImageView = [[UIImageView alloc] initWithFrame:toViewController.view.frame];
        blurredImageView.image = [snapshotImage applyLightEffect];

        toViewController.view.alpha = 0.0;
        [toViewController.view insertSubview:blurredImageView atIndex:0];
        [containerView addSubview:toViewController.view];

        [UIView animateWithDuration:transitonDuration
                         animations:^{
                             toViewController.view.alpha = 1.0;
                         }
                         completion:^(BOOL finished) {
                             [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
                         }];
    }
    else
    {
        UIView *snapshotView = [fromViewController.view resizableSnapshotViewFromRect:fromViewController.view.frame  afterScreenUpdates:YES withCapInsets:UIEdgeInsetsZero];
        snapshotView.frame = [transitionContext finalFrameForViewController:toViewController];
        [containerView addSubview:snapshotView];

        fromViewController.view.alpha = 0.0;

        // add toViewController's view to the view tree to avoid the black background
        UIView *toViewControllerSnapshotView = [toViewController.view resizableSnapshotViewFromRect:toViewController.view.frame  afterScreenUpdates:YES withCapInsets:UIEdgeInsetsZero];
        [containerView insertSubview:toViewControllerSnapshotView belowSubview:snapshotView];

        [UIView animateWithDuration:transitonDuration
                         animations:^{
                             snapshotView.alpha = 0.0;
                         }
                         completion:^(BOOL finished) {
                             [snapshotView removeFromSuperview];
                             [fromViewController.view removeFromSuperview];
                             [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
                         }];
    }
}

@end

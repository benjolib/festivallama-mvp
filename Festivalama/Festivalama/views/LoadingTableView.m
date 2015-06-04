//
//  LoadingTableView.m
//  Festivalama
//
//  Created by Sztanyi Szabolcs on 03/06/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#import "LoadingTableView.h"

@interface LoadingTableView ()
@property (nonatomic, strong) UIImageView *loadingIndicatorView;
@end

@implementation LoadingTableView

- (void)showLoadingIndicator
{
    self.loadingIndicatorView.hidden = NO;
    if (self.loadingIndicatorView) {
        [self bringSubviewToFront:self.loadingIndicatorView];
    }
    [self startRefreshing];
}

- (void)hideLoadingIndicator
{
    self.loadingIndicatorView.hidden = YES;
    [self endRefreshing];
}

- (void)reloadData
{
    [super reloadData];
    if (self.loadingIndicatorView) {
        [self bringSubviewToFront:self.loadingIndicatorView];
    }
}

#pragma mark - private methods
- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setupView];
}

- (void)setupView
{
    self.loadingIndicatorView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"reloadIcon"]];
    self.loadingIndicatorView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.loadingIndicatorView];
}

- (void)updateConstraints
{
    [super updateConstraints];

    [self addConstraints:@[
                           [NSLayoutConstraint constraintWithItem:self.loadingIndicatorView
                                                        attribute:NSLayoutAttributeCenterX
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeCenterX
                                                       multiplier:1
                                                         constant:0],
                           [NSLayoutConstraint constraintWithItem:self.loadingIndicatorView
                                                        attribute:NSLayoutAttributeCenterY
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeCenterY
                                                       multiplier:1
                                                         constant:0]]
     ];
}

- (void)startRefreshing
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.removedOnCompletion = NO;
    animation.toValue = @(M_PI * 2.0);
    animation.duration = 0.8;
    animation.cumulative = YES;
    animation.repeatCount = HUGE_VALF;
    [self.loadingIndicatorView.layer addAnimation:animation forKey:@"rotationAnimation"];
}

- (void)endRefreshing
{
    [self.loadingIndicatorView.layer removeAllAnimations];
}

@end

//
//  LoadingTableView.m
//  Festivalama
//
//  Created by Sztanyi Szabolcs on 03/06/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#import "LoadingTableView.h"
#import "SearchEmptyView.h"

@interface LoadingTableView ()
@property (nonatomic, strong) UIImageView *loadingIndicatorView;
@property (nonatomic, strong) SearchEmptyView *emptyView;
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
    self.userInteractionEnabled = YES;
    if (self.loadingIndicatorView) {
        [self bringSubviewToFront:self.loadingIndicatorView];
    }
}

- (void)showEmptySearchView
{
    self.userInteractionEnabled = NO;
    self.emptyView.hidden = NO;
    if (self.emptyView) {
        [self.emptyView showEmptySearch];
        [self bringSubviewToFront:self.emptyView];
    }
}

- (void)showEmptyFilterView
{
    [self.emptyView showEmptyFilter];
    [self showEmptySearchView];
}

- (void)hideEmptyView
{
    self.userInteractionEnabled = YES;
    self.emptyView.hidden = YES;
}
//
//- (void)layoutSublayersOfLayer:(CALayer *)layer
//{
//    [super layoutSublayersOfLayer:layer];
//    
//}

-(void)layoutSubviews
{
    [super layoutSubviews];
    [self layoutIfNeeded]; // this line is key
}

#pragma mark - private methods
- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setupView];
    [self setupEmptyView];
}

- (void)setupView
{
    self.loadingIndicatorView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"reloadIcon"]];
    self.loadingIndicatorView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.backgroundView addSubview:self.loadingIndicatorView];
}

- (void)setupEmptyView
{
    self.emptyView = [[SearchEmptyView alloc] init];
    self.emptyView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.backgroundView addSubview:self.emptyView];
    self.emptyView.hidden = YES;
}

- (void)updateConstraints
{
    [super updateConstraints];

    if (self.loadingIndicatorView.superview) {
        [self.backgroundView addConstraints:@[
                               [NSLayoutConstraint constraintWithItem:self.loadingIndicatorView
                                                            attribute:NSLayoutAttributeCenterX
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:self.backgroundView
                                                            attribute:NSLayoutAttributeCenterX
                                                           multiplier:1
                                                             constant:0],
                               [NSLayoutConstraint constraintWithItem:self.loadingIndicatorView
                                                            attribute:NSLayoutAttributeCenterY
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:self.backgroundView
                                                            attribute:NSLayoutAttributeCenterY
                                                           multiplier:1
                                                             constant:0]]
         ];
    }

    if (self.emptyView.superview) {
        [self.backgroundView addConstraints:@[
                               [NSLayoutConstraint constraintWithItem:self.emptyView
                                                            attribute:NSLayoutAttributeCenterX
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:self.backgroundView
                                                            attribute:NSLayoutAttributeCenterX
                                                           multiplier:1
                                                             constant:0],
                               [NSLayoutConstraint constraintWithItem:self.emptyView
                                                            attribute:NSLayoutAttributeCenterY
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:self.backgroundView
                                                            attribute:NSLayoutAttributeCenterY
                                                           multiplier:1
                                                             constant:-100]
                               ]];
    }
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

//
//  TableviewCounterView.m
//  Festivalama
//
//  Created by Sztanyi Szabolcs on 01/06/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#import "TableviewCounterView.h"
#import "UIColor+AppColors.h"

@interface TableviewCounterView ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) NSLayoutConstraint *topConstraint;
@end

@implementation TableviewCounterView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.translatesAutoresizingMaskIntoConstraints = NO;
        [self setupView];
    }
    return self;
}

- (void)setupView
{
    self.backgroundColor = [UIColor globalOrangeColor];
    self.layer.cornerRadius = 12.0;

    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(0.0, 2.0);
    self.layer.shadowOpacity = 0.4;
    self.layer.shadowRadius = 2.0;

    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:14.0];
    self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.titleLabel];
}

- (void)setTitle:(NSString*)title
{
    self.titleLabel.text = title;
}

- (void)displayTheNumberOfItems:(NSInteger)festivalCount
{
    self.titleLabel.text = [NSString stringWithFormat:@"%ld Festival%@", (long)festivalCount, (festivalCount <= 1 ? @"" : @"s")];
}

- (void)addToView:(UIView*)view
{
    [view addSubview:self];

    [view addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];

    self.topConstraint = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0];
    [view addConstraint:self.topConstraint];

    [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:25.0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:100.0]];
}

- (BOOL)hasTitle
{
    return self.titleLabel.text.length > 0;
}

- (void)setCounterViewVisible:(BOOL)visible animated:(BOOL)animated
{
    if (visible) {
        self.topConstraint.constant = -10.0;
    } else {
        self.topConstraint.constant = 100.0;
    }

    if (animated) {
        [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            [self layoutIfNeeded];
        } completion:nil];
    } else {
        [self layoutIfNeeded];
    }
}

- (void)updateConstraints
{
    [super updateConstraints];

    [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.titleLabel attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0.0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.titleLabel attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0.0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.titleLabel attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0.0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.titleLabel attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0]];
}

@end

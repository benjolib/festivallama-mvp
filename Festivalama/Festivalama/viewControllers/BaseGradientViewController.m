//
//  BaseGradientViewController.m
//  Festivalama
//
//  Created by Sztanyi Szabolcs on 01/06/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#import "BaseGradientViewController.h"
#import "UIColor+AppColors.h"

@implementation BaseGradientViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addGradientBackground];
}

- (void)addGradientBackground
{
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = self.view.frame;

    UIColor *topColor = [UIColor gradientGreenColor];
    UIColor *bottomColor = [UIColor globalOrangeColor];

    gradientLayer.colors = @[(id)topColor.CGColor, (id)bottomColor.CGColor];
    gradientLayer.locations = @[@0.0, @1.0];
    [self.view.layer insertSublayer:gradientLayer atIndex:0];
}

@end

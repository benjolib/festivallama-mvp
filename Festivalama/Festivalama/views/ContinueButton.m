//
//  ContinueButton.m
//  Festivalama
//
//  Created by Sztanyi Szabolcs on 30/05/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#import "ContinueButton.h"
#import "UIColor+AppColors.h"

@implementation ContinueButton

- (void)awakeFromNib
{
    [super awakeFromNib];

    [self setTitleColor:[UIColor globalOrangeColor] forState:UIControlStateNormal];
    [self setTitleColor:[[UIColor globalOrangeColor] lighterColorWithAlpha:0.6]
               forState:UIControlStateHighlighted];

    self.backgroundColor = [UIColor whiteColor];
    self.imageView.image = [UIImage imageNamed:@"continueButtonArrow"];
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    CGRect iconFrame = self.imageView.frame;
    iconFrame.origin.x = CGRectGetWidth(self.frame) - 30.0;
    self.imageView.frame = iconFrame;
}

@end

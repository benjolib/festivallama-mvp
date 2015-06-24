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

    self.imageView.tintColor = [UIColor globalOrangeColor];
    self.backgroundColor = [UIColor whiteColor];

    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    CGRect iconFrame = self.imageView.frame;
    iconFrame.origin.x = CGRectGetWidth(self.frame) - 20.0;
    self.imageView.frame = iconFrame;
}

- (void)setHighlighted:(BOOL)highlighted
{
    if (highlighted) {
        UIColor *highLightColor = [[UIColor globalOrangeColor] lighterColorWithAlpha:0.6];
        [self setTitleColor:highLightColor forState:UIControlStateHighlighted];
        self.imageView.tintColor = highLightColor;
    } else {
        [self setTitleColor:[UIColor globalOrangeColor] forState:UIControlStateHighlighted];
        self.imageView.tintColor = [UIColor globalOrangeColor];
    }
}

- (void)setEnabled:(BOOL)enabled
{
    [super setEnabled:enabled];
    if (enabled) {
        self.backgroundColor = [UIColor whiteColor];
    } else {
        self.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.3];
    }
}

@end

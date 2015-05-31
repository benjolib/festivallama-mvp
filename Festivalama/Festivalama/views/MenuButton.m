//
//  MenuButton.m
//  Festivalama
//
//  Created by Sztanyi Szabolcs on 31/05/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#import "MenuButton.h"
#import "UIColor+AppColors.h"

@implementation MenuButton

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;

    if (self.titleLabel.text) {
        self.imageView.tintColor = [UIColor globalGreenColor];
    }
    [self setTitleColor:[UIColor globalGreenColor] forState:UIControlStateNormal];
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    CGSize iconSize = self.imageView.image.size;

    CGRect iconFrame = self.imageView.frame;
    iconFrame.origin.x = (CGRectGetWidth(self.frame) / 2) - iconSize.width/2;
    iconFrame.origin.y = 5.0;
    self.imageView.frame = iconFrame;

    CGRect titleFrame = self.titleLabel.frame;
    titleFrame.origin.y = CGRectGetMaxY(self.imageView.frame) + 10.0;
    titleFrame.origin.x = -CGRectGetWidth(self.frame)/2;
    titleFrame.size.width = CGRectGetWidth(self.frame) * 2;
    self.titleLabel.frame = titleFrame;
}

- (void)setHighlighted:(BOOL)highlighted
{
    if (highlighted) {
        self.imageView.tintColor = [UIColor globalGreenColorWithAlpha:0.6];
        [self setTitleColor:[UIColor globalGreenColorWithAlpha:0.6] forState:UIControlStateHighlighted];
    } else {
        self.imageView.tintColor = [UIColor globalGreenColor];
        [self setTitleColor:[UIColor globalGreenColor] forState:UIControlStateNormal];
    }
}

@end

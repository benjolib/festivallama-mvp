//
//  WhiteButton.m
//  Festivalama
//
//  Created by Sztanyi Szabolcs on 10/06/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#import "WhiteButton.h"
#import "UIColor+AppColors.h"

@implementation WhiteButton

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setTitleColor:[UIColor globalOrangeColor] forState:UIControlStateNormal];
    [self setTitleColor:[[UIColor globalOrangeColor] lighterColorWithAlpha:0.6] forState:UIControlStateHighlighted];
    [self setTitleColor:[[UIColor globalOrangeColor] lighterColorWithAlpha:0.1] forState:UIControlStateDisabled];

    self.backgroundColor = [UIColor whiteColor];
}

@end

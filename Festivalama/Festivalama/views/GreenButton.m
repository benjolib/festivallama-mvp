//
//  GreenButton.m
//  Festivalama
//
//  Created by Sztanyi Szabolcs on 31/05/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#import "GreenButton.h"
#import "UIColor+AppColors.h"

@implementation GreenButton

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self setTitleColor:[UIColor colorWithWhite:1.0 alpha:0.6] forState:UIControlStateHighlighted];

    self.backgroundColor = [UIColor globalGreenColor];
}

@end

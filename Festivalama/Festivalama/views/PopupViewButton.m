//
//  PopupViewButton.m
//  Festivalama
//
//  Created by Sztanyi Szabolcs on 28/05/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#import "PopupViewButton.h"
#import "UIColor+AppColors.h"
#import "UIFont+LatoFonts.h"

@implementation PopupViewButton

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.layer.cornerRadius = 30;
        [self.titleLabel setFont:[UIFont latoBoldFontWithSize:18]];
    }
    return self;
}

- (void)setupAsConfirmButton
{
    self.backgroundColor = [UIColor globalGreenColor];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self setTitleColor:[UIColor colorWithWhite:1.0 alpha:0.4] forState:UIControlStateHighlighted];

    self.layer.borderWidth = 0.0;
}

- (void)setupAsCancelButton
{
    UIColor *greenColor = [UIColor colorWithRed:147.0/255.0 green:181.0/255.0 blue:135.0/255.0 alpha:1.0];

    self.backgroundColor = [UIColor clearColor];
    [self setTitleColor:greenColor forState:UIControlStateNormal];
    [self setTitleColor:[greenColor lighterColorWithAlpha:0.4] forState:UIControlStateHighlighted];

    self.layer.borderColor = greenColor.CGColor;
    self.layer.borderWidth = 1.0;
}

@end

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
    self.backgroundColor = [UIColor whiteColor];
    [self setTitleColor:[UIColor globalGreenColor] forState:UIControlStateNormal];
    [self setTitleColor:[UIColor globalGreenColorWithAlpha:0.4] forState:UIControlStateHighlighted];

    self.layer.borderColor = [UIColor globalGreenColor].CGColor;
    self.layer.borderWidth = 1.0;
}

@end

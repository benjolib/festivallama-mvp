//
//  UIColor+AppColors.m
//  Festivalama
//
//  Created by Sztanyi Szabolcs on 28/05/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#import "UIColor+AppColors.h"

#define RGB(r, g, b) [UIColor colorWithRed: r/255.0 green: g/255.0 blue: b/255.0 alpha: 1.0]
#define RGBA(r, g, b, a) [UIColor colorWithRed: r/255.0 green: g/255.0 blue: b/255.0 alpha: a]

@implementation UIColor (AppColors)

+ (UIColor*)globalGreenColor
{
    return [self globalGreenColorWithAlpha:1.0];
}

+ (UIColor*)globalGreenColorWithAlpha:(CGFloat)alpha
{
    return RGBA(122.0, 168.0, 110.0, alpha);
}

+ (UIColor*)globalOrangeColor
{
    return RGB(225.0, 176.0, 104.0);
}

- (UIColor*)lighterColorWithAlpha:(CGFloat)alpha
{
    return [self colorWithAlphaComponent:alpha];
}

+ (UIColor*)gradientGreenColor
{
    return RGB(145.0, 186.0, 136.0);
}

@end

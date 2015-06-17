//
//  UIFont+LatoFonts.m
//  Festivalama
//
//  Created by Sztanyi Szabolcs on 17/06/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#import "UIFont+LatoFonts.h"

@implementation UIFont (LatoFonts)

+ (UIFont*)latoBlackFontWithSize:(CGFloat)size
{
    return [UIFont fontWithName:@"Lato-Black" size:size];
}

+ (UIFont*)latoBlackItalicFontWithSize:(CGFloat)size
{
    return [UIFont fontWithName:@"Lato-BlackItalic" size:size];
}

+ (UIFont*)latoBoldFontWithSize:(CGFloat)size
{
    return [UIFont fontWithName:@"Lato-Bold" size:size];
}

+ (UIFont*)latoBoldItalicFontWithSize:(CGFloat)size
{
    return [UIFont fontWithName:@"Lato-BoldItalic" size:size];
}

+ (UIFont*)latoHairlineFontWithSize:(CGFloat)size
{
    return [UIFont fontWithName:@"Lato-Hairline" size:size];
}

+ (UIFont*)latoHairlineItalicFontWithSize:(CGFloat)size
{
    return [UIFont fontWithName:@"Lato-HairlineItalic" size:size];
}

+ (UIFont*)latoItalicFontWithSize:(CGFloat)size
{
    return [UIFont fontWithName:@"Lato-Italic" size:size];
}

+ (UIFont*)latoRegularFontWithSize:(CGFloat)size
{
    return [UIFont fontWithName:@"Lato-Regular" size:size];
}

+ (UIFont*)latoLightFontWithSize:(CGFloat)size
{
    return [UIFont fontWithName:@"Lato-Light" size:size];
}

+ (UIFont*)latoLightItalicFontWithSize:(CGFloat)size
{
    return [UIFont fontWithName:@"Lato-LightItalic" size:size];
}


@end

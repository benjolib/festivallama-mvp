//
//  UIFont+LatoFonts.h
//  Festivalama
//
//  Created by Sztanyi Szabolcs on 17/06/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIFont (LatoFonts)

+ (UIFont*)latoBlackFontWithSize:(CGFloat)size;
+ (UIFont*)latoBlackItalicFontWithSize:(CGFloat)size;

+ (UIFont*)latoBoldFontWithSize:(CGFloat)size;
+ (UIFont*)latoBoldItalicFontWithSize:(CGFloat)size;

+ (UIFont*)latoHairlineFontWithSize:(CGFloat)size;
+ (UIFont*)latoHairlineItalicFontWithSize:(CGFloat)size;

+ (UIFont*)latoItalicFontWithSize:(CGFloat)size;
+ (UIFont*)latoRegularFontWithSize:(CGFloat)size;

+ (UIFont*)latoLightFontWithSize:(CGFloat)size;
+ (UIFont*)latoLightItalicFontWithSize:(CGFloat)size;

@end

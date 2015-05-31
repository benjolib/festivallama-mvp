//
//  UIColor+AppColors.h
//  Festivalama
//
//  Created by Sztanyi Szabolcs on 28/05/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (AppColors)

+ (UIColor*)globalGreenColor;
+ (UIColor*)globalGreenColorWithAlpha:(CGFloat)alpha;

- (UIColor*)lighterColorWithAlpha:(CGFloat)alpha;

+ (UIColor*)globalOrangeColor;
+ (UIColor*)gradientGreenColor;

@end

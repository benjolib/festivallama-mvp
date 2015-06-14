//
//  FilterButton.m
//  Festivalama
//
//  Created by Sztanyi Szabolcs on 11/06/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#import "FilterButton.h"
#import "UIColor+AppColors.h"

@interface FilterButton ()
@property (nonatomic, strong) UIToolbar *toolbar;
@end

@implementation FilterButton

- (void)awakeFromNib
{
    [super awakeFromNib];

    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
//        self.backgroundColor = [UIColor clearColor];
    }
    else
    {
        self.backgroundColor = [UIColor clearColor];
        UIToolbar *bgToolbar = [[UIToolbar alloc] initWithFrame:self.frame];
        bgToolbar.barStyle = UIBarStyleDefault;
        [self insertSubview:bgToolbar atIndex:0];
    }
}

@end

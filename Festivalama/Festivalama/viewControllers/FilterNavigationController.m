//
//  FilterNavigationController.m
//  Festivalama
//
//  Created by Sztanyi Szabolcs on 31/05/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#import "FilterNavigationController.h"
#import "UIColor+AppColors.h"
#import "UIFont+LatoFonts.h"

@implementation FilterNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[UINavigationBar appearance] setTintColor:[UIColor globalGreenColor]];
    [[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor globalGreenColor], NSFontAttributeName: [UIFont latoRegularFontWithSize:20.0]}];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

@end

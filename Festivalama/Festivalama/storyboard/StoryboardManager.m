//
//  StoryboardManager.m
//  Festivalama
//
//  Created by Sztanyi Szabolcs on 28/05/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#import "StoryboardManager.h"

@implementation StoryboardManager

+ (UIStoryboard*)mainStoryboard
{
    return [UIStoryboard storyboardWithName:@"Main" bundle:nil];
}

+ (UIStoryboard*)filterStoryboard
{
    return [UIStoryboard storyboardWithName:@"Filter" bundle:nil];
}

#pragma mark - viewControllers
+ (MenuViewController*)menuViewController
{
   return [[self mainStoryboard] instantiateViewControllerWithIdentifier:@"MenuViewController"];
}

+ (FilterNavigationController*)filterNavigationController
{
    return [[self filterStoryboard] instantiateViewControllerWithIdentifier:@"FilterNavigationController"];
}

+ (FestivalNavigationController*)festivalNavigationController
{
    return [[self mainStoryboard] instantiateViewControllerWithIdentifier:@"FestivalNavigationController"];
}

+ (FestivalsViewController*)festivalsViewController
{
   return [[self mainStoryboard] instantiateViewControllerWithIdentifier:@"FestivalsViewController"];
}

@end

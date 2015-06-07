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
    return [self festivalNavigationControllerWithID:@"FestivalNavigationController"];
}

+ (FestivalNavigationController*)festivalNavigationControllerWithID:(NSString*)identifier
{
    return [[self mainStoryboard] instantiateViewControllerWithIdentifier:identifier];
}

+ (FestivalsViewController*)festivalsViewController
{
   return [[self mainStoryboard] instantiateViewControllerWithIdentifier:@"FestivalsViewController"];
}

+ (PopularFestivalsViewController*)popularFestivalsViewController
{
   return [[self mainStoryboard] instantiateViewControllerWithIdentifier:@"PopularFestivalsViewController"];
}

+ (FestivalDetailInfoViewController*)festivalDetailInfoViewController
{
    return [[self mainStoryboard] instantiateViewControllerWithIdentifier:@"FestivalDetailInfoViewController"];
}

+ (FestivalDetailBandsViewController*)festivalDetailBandsViewController
{
    return [[self mainStoryboard] instantiateViewControllerWithIdentifier:@"FestivalDetailBandsViewController"];
}

+ (FestivalDetailLocationViewController*)festivalDetailLocationViewController
{
    return [[self mainStoryboard] instantiateViewControllerWithIdentifier:@"FestivalDetailLocationViewController"];
}

@end

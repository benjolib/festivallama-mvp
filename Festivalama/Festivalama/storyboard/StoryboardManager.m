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

+ (MenuViewController*)menuViewController
{
   return [[self mainStoryboard] instantiateViewControllerWithIdentifier:@"MenuViewController"];
}

@end

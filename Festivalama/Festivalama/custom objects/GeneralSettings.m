//
//  GeneralSettings.m
//  Festivalama
//
//  Created by Sztanyi Szabolcs on 04/06/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#import "GeneralSettings.h"

static NSString * const kOnboardingViewedKey = @"onboardingViewed";

@implementation GeneralSettings

+ (void)setOnboardingViewed
{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kOnboardingViewedKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL)onboardingViewed
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:kOnboardingViewedKey];
}

@end

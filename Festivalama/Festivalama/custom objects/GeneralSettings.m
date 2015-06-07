//
//  GeneralSettings.m
//  Festivalama
//
//  Created by Sztanyi Szabolcs on 04/06/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#import "GeneralSettings.h"

static NSString * const kOnboardingViewedKey = @"onboardingViewed";
static NSString * const kTutorialShownKey = @"tutorialShownKey";

@implementation GeneralSettings

+ (void)setOnboardingViewed
{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kOnboardingViewedKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)setTutorialsShown
{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kTutorialShownKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL)onboardingViewed
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:kOnboardingViewedKey];
}

+ (BOOL)wasTutorialShown
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:kTutorialShownKey];
}

@end

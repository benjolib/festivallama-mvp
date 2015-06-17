//
//  GeneralSettings.h
//  Festivalama
//
//  Created by Sztanyi Szabolcs on 04/06/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GeneralSettings : NSObject

+ (void)setOnboardingViewed;
+ (BOOL)onboardingViewed;

+ (void)setTutorialsShown;
+ (BOOL)wasTutorialShown;

+ (void)setOnTrackPromptWasShown;
+ (BOOL)wasOnTrackPromptShown;

+ (void)setRateAppWasShown;
+ (BOOL)wasRateAppShown;

+ (void)saveAppStartDate;
+ (NSTimeInterval)passedIntervalSinceAppStart;

@end

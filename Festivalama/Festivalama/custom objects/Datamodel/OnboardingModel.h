//
//  OnboardingModel.h
//  Festivalama
//
//  Created by Sztanyi Szabolcs on 30/05/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@class Genre, OnboardingOption;

@interface OnboardingModel : NSObject

@property (nonatomic, strong) CLLocation *userLocation;
@property (nonatomic, strong) NSArray *selectedGenres;
@property (nonatomic) BOOL filterByGermany;
@property (nonatomic, strong) NSMutableDictionary *selectedOptionAtScreensDictionary;

// default values to display
@property (nonatomic, strong, readonly) NSMutableArray *visitorOptionsArray;
@property (nonatomic, strong, readonly) NSMutableArray *travelOptionsArray;
@property (nonatomic, strong, readonly) NSMutableArray *friendsCountArray;
@property (nonatomic, strong, readonly) NSMutableArray *overnightArray;

- (NSArray*)onboardingOptionsArrayForIndex:(NSInteger)index;
- (NSString*)onboardingViewTitleForIndex:(NSInteger)index;
- (NSString*)onboardingBackgroundImageViewNameForIndex:(NSInteger)index;

- (void)userSelectedOption:(OnboardingOption*)option atScreenIndex:(NSInteger)index;

@end

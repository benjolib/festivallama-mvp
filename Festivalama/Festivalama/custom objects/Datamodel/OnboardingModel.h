//
//  OnboardingModel.h
//  Festivalama
//
//  Created by Sztanyi Szabolcs on 30/05/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Genre;

@interface OnboardingModel : NSObject

@property (nonatomic, strong) NSArray *selectedGenres;

// default values to display
@property (nonatomic, strong, readonly) NSMutableArray *visitorOptionsArray;
@property (nonatomic, strong, readonly) NSMutableArray *travelOptionsArray;
@property (nonatomic, strong, readonly) NSMutableArray *friendsCountArray;
@property (nonatomic, strong, readonly) NSMutableArray *overnightArray;

@property (nonatomic) BOOL filterByGermany;

- (NSArray*)onboardingOptionsArrayForIndex:(NSInteger)index;
- (NSString*)onboardingViewTitleForIndex:(NSInteger)index;
- (NSString*)onboardingBackgroundImageViewNameForIndex:(NSInteger)index;

@end

//
//  FilterModel.h
//  Festivalama
//
//  Created by Sztanyi Szabolcs on 31/05/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

// Object to hold all the selected filtering options

@class OnboardingModel, FilterPostcode;

@interface FilterModel : NSObject

@property (nonatomic, strong) NSArray *selectedGenresArray;
@property (nonatomic, strong) NSArray *selectedBandsArray;
@property (nonatomic, strong) NSArray *selectedPostcodesArray;
@property (nonatomic, strong) NSArray *selectedCountriesArray;
@property (nonatomic, copy) NSString *selectedCountry;
@property (nonatomic, strong) CLLocation *userLocation;
@property (nonatomic, strong) FilterPostcode *selectedPostCode;

+ (instancetype)sharedModel;

- (void)copySettingsFromOnboardingModel:(OnboardingModel*)onboarding;
- (void)copySettingsFromFilterModel:(FilterModel*)filterModel;
- (void)clearFilters;

- (BOOL)isFiltering;
- (BOOL)isSelectedCountryGermany;


- (NSString*)bandsString;
- (NSString*)genresString;

- (NSString*)countriesStringForAPICall;
- (NSString*)postcodeStringForAPICall;
- (NSString*)bandsStringForAPICall;
- (NSString*)genresStringForAPICall;

@end

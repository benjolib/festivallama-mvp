//
//  FilterModel.m
//  Festivalama
//
//  Created by Sztanyi Szabolcs on 31/05/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#import "FilterModel.h"
#import "Band.h"
#import "Genre.h"
#import "OnboardingModel.h"

@implementation FilterModel

+ (instancetype)sharedModel
{
    static FilterModel *sharedModel = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedModel = [[FilterModel alloc] init];
    });
    return sharedModel;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.selectedBandsArray = [NSArray array];
        self.selectedGenresArray = [NSArray array];
    }
    return self;
}

- (void)copySettingsFromOnboardingModel:(OnboardingModel*)onboarding
{
    self.selectedGenresArray = [[onboarding selectedGenres] copy];
    if (onboarding.filterByGermany) {
        self.selectedCountry = @"germany";
    }
}

- (void)clearFilters
{
    self.selectedCountry = nil;
    self.selectedGenresArray = nil;
    self.selectedPostCode = nil;
    self.selectedBandsArray = nil;
}

- (BOOL)isFiltering
{
    if (self.selectedCountry) {
        return YES;
    } else if (self.selectedPostCode) {
        return YES;
    } else if (self.selectedGenresArray.count > 0) {
        return YES;
    } else if (self.selectedBandsArray.count > 0) {
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)isSelectedCountryGermany
{
    return [self.selectedCountry isEqualToString:@"Deutschland"];
}

- (NSString*)bandsString
{
    NSMutableString *bandsString = [[NSMutableString alloc] init];
    for (int i = 0; i < self.selectedBandsArray.count; i++) {
        Band *band = self.selectedBandsArray[i];
        [bandsString appendString:band.name];
        if (i != self.selectedBandsArray.count-1) {
            [bandsString appendString:@", "];
        }
    }

    return bandsString;
}

- (NSString*)genresString
{
    NSMutableString *genresString = [[NSMutableString alloc] init];
    for (int i = 0; i < self.selectedGenresArray.count; i++) {
        Genre *genre = self.selectedGenresArray[i];
        [genresString appendString:genre.name];
        if (i != self.selectedBandsArray.count-1) {
            [genresString appendString:@", "];
        }
    }

    return genresString;
}

- (NSString*)bandsStringForAPICall
{
    return [[self bandsString] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

- (NSString*)genresStringForAPICall
{
    return [[self genresString] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

@end

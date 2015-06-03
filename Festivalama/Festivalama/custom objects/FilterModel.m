//
//  FilterModel.m
//  Festivalama
//
//  Created by Sztanyi Szabolcs on 31/05/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#import "FilterModel.h"
#import "Band.h"

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

- (NSString*)bandsString
{
    NSMutableString *bandsString = [[NSMutableString alloc] init];
    for (int i = 0; i < self.selectedBandsArray.count; i++) {
        Band *band = self.selectedBandsArray[i];
        [bandsString appendString:band.name];
        if (i-1 != self.selectedBandsArray.count) {
            [bandsString appendString:@","];
        }
    }

    return bandsString;
}

@end

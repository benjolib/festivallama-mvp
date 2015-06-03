//
//  FilterModel.h
//  Festivalama
//
//  Created by Sztanyi Szabolcs on 31/05/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#import <Foundation/Foundation.h>

// Object to hold all the selected filtering options

@interface FilterModel : NSObject

@property (nonatomic, strong) NSArray *selectedGenresArray;
@property (nonatomic, strong) NSArray *selectedBandsArray;
@property (nonatomic, copy) NSString *selectedCountry;
@property (nonatomic, copy) NSString *selectedPostCode;

+ (instancetype)sharedModel;

- (BOOL)isFiltering;
- (void)clearFilters;
- (NSString*)bandsString;

@end

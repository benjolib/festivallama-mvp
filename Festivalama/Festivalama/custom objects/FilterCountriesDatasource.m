//
//  FilterCountriesDatasource.m
//  Festivalama
//
//  Created by Sztanyi Szabolcs on 01/06/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#import "FilterCountriesDatasource.h"
#import "Country.h"

@interface FilterCountriesDatasource ()
@property (nonatomic, strong) NSArray *allCountriesArray;
@property (nonatomic, strong) NSArray *countriesArray;
@end

@implementation FilterCountriesDatasource

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    NSMutableArray *tempArray = [NSMutableArray array];

    [tempArray addObject:[Country countryWithName:@"Österreich" flag:@"austria"]];
    [tempArray addObject:[Country countryWithName:@"Belgien" flag:@"belgium"]];
    [tempArray addObject:[Country countryWithName:@"Kroatien" flag:@"kroatien"]];
    [tempArray addObject:[Country countryWithName:@"Tschechien" flag:@"tschechien"]];
    [tempArray addObject:[Country countryWithName:@"Dänemark" flag:@"denmark"]];
    [tempArray addObject:[Country countryWithName:@"Finnland" flag:@"finnland"]];
    [tempArray addObject:[Country countryWithName:@"Frankreich" flag:@"france"]];
    [tempArray addObject:[Country countryWithName:@"Deutschland" flag:@"germany"]];
    [tempArray addObject:[Country countryWithName:@"Ungarn" flag:@"hungary"]];
    [tempArray addObject:[Country countryWithName:@"Island" flag:@"iceland"]];
    [tempArray addObject:[Country countryWithName:@"Italien" flag:@"italy"]];
    [tempArray addObject:[Country countryWithName:@"Luxemburg" flag:@"luxemburg"]];
    [tempArray addObject:[Country countryWithName:@"Niederlande" flag:@"netherlands"]];
    [tempArray addObject:[Country countryWithName:@"Norwegen" flag:@"norway"]];
    [tempArray addObject:[Country countryWithName:@"Polen" flag:@"poland"]];
    [tempArray addObject:[Country countryWithName:@"Portugal" flag:@"portugal"]];
    [tempArray addObject:[Country countryWithName:@"Rumänien" flag:@"romania"]];
    [tempArray addObject:[Country countryWithName:@"Slowakai" flag:@"slovakia"]];
    [tempArray addObject:[Country countryWithName:@"Slowenien" flag:@"slovenia"]];
    [tempArray addObject:[Country countryWithName:@"Spanien" flag:@"spain"]];
    [tempArray addObject:[Country countryWithName:@"Schweden" flag:@"sweden"]];
    [tempArray addObject:[Country countryWithName:@"Grossbritannien" flag:@"united_kingdom"]];
    [tempArray addObject:[Country countryWithName:@"Schweiz" flag:@"switzerland"]];

    self.countriesArray = [tempArray sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]]];
}

- (NSArray*)allCountries
{
    return self.countriesArray;
}

@end

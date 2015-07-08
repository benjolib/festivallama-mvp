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

    [tempArray addObject:[Country countryWithName:@"Belgien" flag:@"belgium"]];
    [tempArray addObject:[Country countryWithName:@"Daenemark" flag:@"denmark"]];
    [tempArray addObject:[Country countryWithName:@"Deutschland" flag:@"germany"]];
    [tempArray addObject:[Country countryWithName:@"England" flag:@"united_kingdom"]];
    [tempArray addObject:[Country countryWithName:@"Finnland" flag:@"finnland"]];
    [tempArray addObject:[Country countryWithName:@"Frankreich" flag:@"france"]];
    [tempArray addObject:[Country countryWithName:@"Griechenland" flag:@"greece"]];
    [tempArray addObject:[Country countryWithName:@"Holland" flag:@"netherlands"]];
    [tempArray addObject:[Country countryWithName:@"Irland" flag:@"irland"]];
    [tempArray addObject:[Country countryWithName:@"Island" flag:@"iceland"]];
    [tempArray addObject:[Country countryWithName:@"Italien" flag:@"italy"]];
    [tempArray addObject:[Country countryWithName:@"Kroatien" flag:@"kroatien"]];
    [tempArray addObject:[Country countryWithName:@"Lettland" flag:@"lettland"]];
    [tempArray addObject:[Country countryWithName:@"Luxemburg" flag:@"luxemburg"]];
    [tempArray addObject:[Country countryWithName:@"Montenegro" flag:@"montenegro"]];
    [tempArray addObject:[Country countryWithName:@"Norwegen" flag:@"norway"]];
    [tempArray addObject:[Country countryWithName:@"Oesterreich" flag:@"austria"]];
    [tempArray addObject:[Country countryWithName:@"Polen" flag:@"poland"]];
    [tempArray addObject:[Country countryWithName:@"Portugal" flag:@"portugal"]];
    [tempArray addObject:[Country countryWithName:@"Rumaenien" flag:@"romania"]];
    [tempArray addObject:[Country countryWithName:@"Russland" flag:@"russland"]];
    [tempArray addObject:[Country countryWithName:@"Schottland" flag:@"scottland"]];
    [tempArray addObject:[Country countryWithName:@"Schweden" flag:@"sweden"]];
    [tempArray addObject:[Country countryWithName:@"Schweiz" flag:@"switzerland"]];
    [tempArray addObject:[Country countryWithName:@"Serbien" flag:@"serbien"]];
    [tempArray addObject:[Country countryWithName:@"Slowakei" flag:@"slovakia"]];
    [tempArray addObject:[Country countryWithName:@"Slowenien" flag:@"slovenia"]];
    [tempArray addObject:[Country countryWithName:@"Spanien" flag:@"spain"]];
    [tempArray addObject:[Country countryWithName:@"Tschechien" flag:@"tschechien"]];
    [tempArray addObject:[Country countryWithName:@"Tuerkei" flag:@"turkei"]];
    [tempArray addObject:[Country countryWithName:@"Ungarn" flag:@"hungary"]];
    [tempArray addObject:[Country countryWithName:@"Wales" flag:@"wales"]];





    self.countriesArray = [tempArray sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]]];
}

- (NSArray*)allCountries
{
    return self.countriesArray;
}

@end

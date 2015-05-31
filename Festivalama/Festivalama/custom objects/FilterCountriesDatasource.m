//
//  FilterCountriesDatasource.m
//  Festivalama
//
//  Created by Sztanyi Szabolcs on 01/06/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#import "FilterCountriesDatasource.h"

@interface FilterCountriesDatasource ()
@property (nonatomic, strong) NSArray *allCountriesArray;
@end

@implementation FilterCountriesDatasource

- (NSArray *)countryNames
{
    if (!_allCountriesArray) {
        _allCountriesArray = [[[[self countryNamesByCode] allValues] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)] copy];
    }
    return _allCountriesArray;
}

- (NSArray *)countryCodes
{
    static NSArray *_countryCodes = nil;
    if (!_countryCodes) {
        _countryCodes = [[[self countryCodesByName] objectsForKeys:[self countryNames] notFoundMarker:@""] copy];
    }
    return _countryCodes;
}

- (NSDictionary *)countryNamesByCode
{
    static NSDictionary *_countryNamesByCode = nil;
    if (!_countryNamesByCode)
    {
        NSMutableDictionary *namesByCode = [NSMutableDictionary dictionary];
        for (NSString *code in [NSLocale ISOCountryCodes])
        {
            NSString *countryName = [[NSLocale currentLocale] displayNameForKey:NSLocaleCountryCode value:code];

            //workaround for simulator bug
            if (!countryName)
            {
                countryName = [[NSLocale localeWithLocaleIdentifier:@"en_US"] displayNameForKey:NSLocaleCountryCode value:code];
            }

            namesByCode[code] = countryName ?: code;
        }
        _countryNamesByCode = [namesByCode copy];
    }
    return _countryNamesByCode;
}

- (NSDictionary *)countryCodesByName
{
    static NSDictionary *_countryCodesByName = nil;
    if (!_countryCodesByName)
    {
        NSDictionary *countryNamesByCode = [self countryNamesByCode];
        NSMutableDictionary *codesByName = [NSMutableDictionary dictionary];
        for (NSString *code in countryNamesByCode)
        {
            codesByName[countryNamesByCode[code]] = code;
        }
        _countryCodesByName = [codesByName copy];
    }
    return _countryCodesByName;
}

- (NSString *)countryNameAtIndex:(NSInteger)index
{
    return [self allCountriesArray][index];
}

- (UIImage*)flagIconAtIndex:(NSInteger)index
{
    NSString *imagePath = [NSString stringWithFormat:@"CountryPicker.bundle/%@", [self countryCodes][index]];
    return [UIImage imageNamed:imagePath];
}

@end

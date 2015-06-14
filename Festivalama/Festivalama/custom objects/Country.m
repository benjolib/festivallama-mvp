//
//  Country.m
//  Festivalama
//
//  Created by Sztanyi Szabolcs on 15/06/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#import "Country.h"

@implementation Country

+ (Country*)countryWithName:(NSString*)name flag:(NSString*)flag
{
    Country *country = [Country new];
    country.name = name;
    country.flag = flag;

    return country;
}

@end

//
//  FestivalModel.m
//  Festivalama
//
//  Created by Sztanyi Szabolcs on 02/06/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#import "FestivalModel.h"
#import "NSDictionary+nonNullObjectForKey.h"

@implementation FestivalModel

+ (FestivalModel*)festivalModelFromDictionary:(NSDictionary*)dictionary
{
    FestivalModel *festival = [FestivalModel new];
    festival.name = [dictionary nonNullObjectForKey:@"name"];
    festival.festivalID = [dictionary nonNullObjectForKey:@"id"];
    festival.festivalKey = [dictionary nonNullObjectForKey:@"festival_key"];
    festival.address = [dictionary nonNullObjectForKey:@"address"];
    festival.postcode = [dictionary nonNullObjectForKey:@"zip"];
    festival.city = [dictionary nonNullObjectForKey:@"city"];
    festival.country = [dictionary nonNullObjectForKey:@"country"];
    festival.locationName = [dictionary nonNullObjectForKey:@"location"];
    festival.phoneNumber = [dictionary nonNullObjectForKey:@"info_tel"];
    festival.website = [dictionary nonNullObjectForKey:@"website"];
    festival.sourceURL = [dictionary nonNullObjectForKey:@"source_url"];
    festival.festivalDescription = [dictionary nonNullObjectForKey:@"description"];
    festival.admission = [dictionary nonNullObjectForKey:@"admission"];
    festival.category = [dictionary nonNullObjectForKey:@"category"];

    // TODO: dates
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"YYYY-MM-dd";

    NSString *startDateString = [dictionary nonNullObjectForKey:@"date_start"];
    NSString *endDateString = [dictionary nonNullObjectForKey:@"date_end"];
    if (startDateString) {
        NSDate *startDate = [dateFormatter dateFromString:startDateString];
        festival.startDate = startDate;
    }
    if (endDateString) {
        NSDate *endDate = [dateFormatter dateFromString:endDateString];
        festival.endDate = endDate;
    }

    festival.bandsArray = [dictionary nonNullObjectForKey:@"bands"];
    festival.genresArray = [dictionary nonNullObjectForKey:@"genre"];

    return festival;
}

- (NSString*)locationAddress
{
    return [NSString stringWithFormat:@"%@, %@", self.city, self.country];
}

@end

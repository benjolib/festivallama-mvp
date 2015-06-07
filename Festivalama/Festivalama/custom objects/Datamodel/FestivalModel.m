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

- (NSString*)calendarDaysTillEndDateString
{
    if (!self.endDate) {
        return nil;
    }
    NSInteger numberOfDaysLeft = [self daysTillStartDate];
    if (numberOfDaysLeft == 0) {
        // TODO:
        return nil;
    }
    return [NSString stringWithFormat:@"In %ld Tagen", (long)numberOfDaysLeft];
}

- (NSInteger)daysTillStartDate
{
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [gregorianCalendar components:NSDayCalendarUnit
                                                        fromDate:[NSDate date]
                                                          toDate:self.startDate
                                                         options:0];
    NSInteger numberOfDays = components.day;
    if (numberOfDays < 0) {
        numberOfDays *= -1;
    }
    return numberOfDays;
}


#pragma mark - info view methods
- (NSString*)infoLocationString
{
    return [NSString stringWithFormat:@"%@ (%@)", self.city, self.country];
}

- (NSString*)festivalInfoDateString
{
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *startComponents = [gregorianCalendar components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:self.startDate];
    NSInteger startDay = startComponents.day;
    NSInteger startMonth = startComponents.month;
    NSInteger startYear = startComponents.year;

    NSDateComponents *endComponents = [gregorianCalendar components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:self.endDate];
    NSInteger endDay = endComponents.day;
//    NSInteger endMonth = endComponents.month;
//    NSInteger endYear = endComponents.year;

    NSString *formattedInfoDateString = nil;
    if (startDay && endDay)
    {
        formattedInfoDateString = [NSString stringWithFormat:@"%ld.-%ld. %ld %ld", (long)startDay, (long)endDay, (long)startMonth, (long)startYear];
        return formattedInfoDateString;
    } else {
        formattedInfoDateString = [NSString stringWithFormat:@"%ld. %ld %ld", (long)startDay, (long)startMonth, (long)startYear];
        return formattedInfoDateString;
    }

    return formattedInfoDateString;
}


@end

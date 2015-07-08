//
//  FestivalModel.m
//  Festivalama
//
//  Created by Sztanyi Szabolcs on 02/06/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#import "FestivalModel.h"
#import "NSDictionary+nonNullObjectForKey.h"
#import "Band.h"
#import "Genre.h"

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
    festival.rank = [dictionary nonNullObjectForKey:@"rank"];

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"YYYY-MM-dd";

    NSString *startDateString = [dictionary nonNullObjectForKey:@"date_start"];
    NSString *endDateString = [dictionary nonNullObjectForKey:@"date_end"];
    if (startDateString) {
        NSDate *startDate = [dateFormatter dateFromString:startDateString];
        festival.startDate = startDate;
        festival.startDateString = startDateString;
    }
    if (endDateString) {
        NSDate *endDate = [dateFormatter dateFromString:endDateString];
        festival.endDate = endDate;
        festival.startDateString = endDateString;
    }

    NSArray *bandsArray = [dictionary nonNullObjectForKey:@"bands"];
    festival.bandsArray = [Band bandsArrayFromStringArray:bandsArray];

    NSArray *genresArray = [dictionary nonNullObjectForKey:@"genre"];
    festival.genresArray = [Genre genresFromArray:genresArray];

    return festival;
}

- (NSString*)locationAddress
{
    return [NSString stringWithFormat:@"%@, %@", self.city, self.country];
}

- (NSString*)calendarDaysTillStartDateString
{
    if (!self.startDate) {
        return nil;
    }
    NSInteger numberOfDaysLeft = [self daysTillStartDate];
    if (numberOfDaysLeft <= 0) {
        return [NSString stringWithFormat:@"Jetzt"];
    }
    return [NSString stringWithFormat:@"In %ld Tagen", (long)numberOfDaysLeft];
}

- (NSInteger)daysTillStartDate
{
    if (!self.startDate) {
        return 0;
    }
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [gregorianCalendar components:NSDayCalendarUnit
                                                        fromDate:[NSDate date]
                                                          toDate:self.startDate
                                                         options:0];
    NSInteger numberOfDays = components.day;
    return numberOfDays;
}

#pragma mark - info view methods
- (NSString*)infoLocationString
{
    return [NSString stringWithFormat:@"%@ (%@)", self.city, self.country];
}

- (NSString*)festivalInfoDateString
{
    if (!self.startDate) {
        return nil;
    }
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *startComponents = [gregorianCalendar components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:self.startDate];
    NSInteger startDay = startComponents.day;
    NSInteger startMonth = startComponents.month;
    NSInteger startYear = startComponents.year;

    NSDateFormatter *monthFormatter = [[NSDateFormatter alloc] init];
    NSString *startMonthName = [[monthFormatter monthSymbols] objectAtIndex:(startMonth-1)];

    if (!self.endDate) {
        return [NSString stringWithFormat:@"%ld. %@. %ld", (long)startDay, startMonthName, (long)startYear];
    }

    NSDateComponents *endComponents = [gregorianCalendar components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:self.endDate];
    NSInteger endDay = endComponents.day;
    NSInteger endMonth = endComponents.month;

    NSString *endMonthName = [[monthFormatter monthSymbols] objectAtIndex:(endMonth-1)];

    NSString *formattedInfoDateString = nil;
    if (startDay && endDay)
    {
        if (startMonth != endMonth) {
            formattedInfoDateString = [NSString stringWithFormat:@"%ld. %@. - %ld. %@. %ld", (long)startDay, startMonthName, (long)endDay, endMonthName, (long)startYear];
        } else {
            formattedInfoDateString = [NSString stringWithFormat:@"%ld-%ld. %@. %ld", (long)startDay, (long)endDay, startMonthName, (long)startYear];
        }
        return formattedInfoDateString;
    }

    return formattedInfoDateString;
}

- (BOOL)isEqual:(id)object
{
    if ([object isKindOfClass:[self class]]) {
        FestivalModel *model = (FestivalModel*)object;
        if ([model.festivalID isEqualToString:self.festivalID]) {
            return YES;
        }
    }

    return NO;
}

@end

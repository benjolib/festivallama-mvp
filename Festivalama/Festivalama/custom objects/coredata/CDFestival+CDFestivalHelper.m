//
//  CDFestival+CDFestivalHelper.m
//  Festivalama
//
//  Created by Sztanyi Szabolcs on 11/06/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#import "CDFestival+CDFestivalHelper.h"
#import "FestivalModel.h"
#import "Band.h"
#import "Genre.h"
#import "CDBand.h"
#import "CDGenre.h"

@implementation CDFestival (CDFestivalHelper)

- (FestivalModel*)festivalModel
{
    FestivalModel *festival = [FestivalModel new];
    festival.name = self.name;
    festival.festivalID = self.festivalID;
    festival.festivalKey = self.festivalKey;
    festival.address = self.address;
    festival.postcode = self.postcode;
    festival.city = self.city;
    festival.country = self.country;
    festival.locationName = self.locationName;
    festival.phoneNumber = self.phoneNumber;
    festival.website = self.website;
    festival.sourceURL = self.sourceURL;
    festival.festivalDescription = self.festivalDescription;
    festival.admission = self.admission;
    festival.category = self.category;
    festival.rank = self.rank;
    festival.startDate = self.startDate;
    festival.endDate = self.endDate;
    festival.bandsArray = [self bandsArray];
    festival.genresArray = [self genresArray];

    return festival;
}

- (NSArray*)bandsArray
{
    NSMutableArray *tempArray = [NSMutableArray array];
    for (CDBand *band in self.bands.allObjects) {
        [tempArray addObject:[Band bandWithName:band.name]];
    }
    return tempArray;
}

- (NSArray*)genresArray
{
    NSMutableArray *tempArray = [NSMutableArray array];
    for (CDGenre *genre in self.genres.allObjects) {
        [tempArray addObject:[Genre genreWithName:genre.name]];
    }
    return tempArray;
}

@end

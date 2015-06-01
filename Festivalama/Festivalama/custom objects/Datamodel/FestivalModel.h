//
//  FestivalModel.h
//  Festivalama
//
//  Created by Sztanyi Szabolcs on 02/06/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FestivalModel : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *festivalID;
@property (nonatomic, copy) NSString *festivalKey;

@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *postcode;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *country;
@property (nonatomic, copy) NSString *locationName;

@property (nonatomic, copy) NSString *phoneNumber;
@property (nonatomic, copy) NSString *website;
@property (nonatomic, copy) NSString *sourceURL;
@property (nonatomic, copy) NSString *festivalDescription;

@property (nonatomic, copy) NSString *admission;
@property (nonatomic, copy) NSString *category;

@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) NSDate *endDate;

@property (nonatomic, strong) NSArray *bandsArray;
@property (nonatomic, strong) NSArray *genresArray;

+ (FestivalModel*)festivalModelFromDictionary:(NSDictionary*)dictionary;

- (NSString*)locationAddress;

@end

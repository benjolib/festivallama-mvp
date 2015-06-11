//
//  CDFestival.h
//  Festivalama
//
//  Created by Sztanyi Szabolcs on 11/06/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class NSManagedObject;

@interface CDFestival : NSManagedObject

@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSString * admission;
@property (nonatomic, retain) NSString * website;
@property (nonatomic, retain) NSDate * startDate;
@property (nonatomic, retain) NSString * sourceURL;
@property (nonatomic, retain) NSNumber * rank;
@property (nonatomic, retain) NSString * postcode;
@property (nonatomic, retain) NSString * phoneNumber;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * locationName;
@property (nonatomic, retain) NSString * festivalKey;
@property (nonatomic, retain) NSString * festivalID;
@property (nonatomic, retain) NSString * festivalDescription;
@property (nonatomic, retain) NSDate * endDate;
@property (nonatomic, retain) NSString * country;
@property (nonatomic, retain) NSString * city;
@property (nonatomic, retain) NSString * category;
@property (nonatomic, retain) NSSet *bands;
@property (nonatomic, retain) NSSet *genres;
@end

@interface CDFestival (CoreDataGeneratedAccessors)

- (void)addBandsObject:(NSManagedObject *)value;
- (void)removeBandsObject:(NSManagedObject *)value;
- (void)addBands:(NSSet *)values;
- (void)removeBands:(NSSet *)values;

- (void)addGenresObject:(NSManagedObject *)value;
- (void)removeGenresObject:(NSManagedObject *)value;
- (void)addGenres:(NSSet *)values;
- (void)removeGenres:(NSSet *)values;

@end

//
//  CoreDataHandler.h
//  Festivalama
//
//  Created by Sztanyi Szabolcs on 07/06/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class FestivalModel, CDFestival;

@interface CoreDataHandler : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *mainManagedObjectContext;

+ (instancetype)sharedHandler;
- (NSArray*)allSavedFestivals;

- (void)addFestivalToFavorites:(FestivalModel*)festivalModel;
- (void)removeFestivalFromFavorites:(FestivalModel*)festivalModel;
- (void)removeFestivalObject:(CDFestival*)festival;

- (BOOL)isFestivalSaved:(FestivalModel*)festivalModel;

- (NSInteger)numberOfSavedFestivals;
- (void)clearDatabase;

@end

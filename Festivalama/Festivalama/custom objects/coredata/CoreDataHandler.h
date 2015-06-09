//
//  CoreDataHandler.h
//  Festivalama
//
//  Created by Sztanyi Szabolcs on 07/06/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FestivalModel;

@interface CoreDataHandler : NSObject

- (void)addFestivalToFavorites:(FestivalModel*)festivalModel;
- (void)removeFestivalFromFavorites:(FestivalModel*)festivalModel;

@end

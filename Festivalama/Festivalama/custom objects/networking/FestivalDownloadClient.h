//
//  FestivalDownloadClient.h
//  Festivalama
//
//  Created by Sztanyi Szabolcs on 02/06/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#import "AbstractClient.h"

@class FilterModel;

@interface FestivalDownloadClient : AbstractClient

- (void)downloadAllFestivalsWithCompletionBlock:(void (^)(NSArray *festivalsArray, NSString *errorMessage, BOOL completed))completionBlock;

- (void)downloadFestivalsFromIndex:(NSInteger)startIndex limit:(NSInteger)numberOfItems filterModel:(FilterModel*)filterModel andCompletionBlock:(void (^)(NSArray *festivalsArray, NSString *errorMessage, BOOL completed))completionBlock;

- (void)downloadFestivalsWithFilterModel:(FilterModel*)filterModel andCompletionBlock:(void (^)(NSArray *festivalsArray, NSString *errorMessage, BOOL completed))completionBlock;

- (void)downloadPopularFestivalsFromIndex:(NSInteger)startIndex limit:(NSInteger)numberOfItems filterModel:(FilterModel*)filterModel andCompletionBlock:(void (^)(NSArray *festivalsArray, NSString *errorMessage, BOOL completed))completionBlock;

@end

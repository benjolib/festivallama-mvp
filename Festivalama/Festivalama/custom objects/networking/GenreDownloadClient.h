//
//  GenreDownloadClient.h
//  Festivalama
//
//  Created by Sztanyi Szabolcs on 28/05/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#import "AbstractClient.h"

@interface GenreDownloadClient : AbstractClient

- (void)downloadAllGenresWithCompletionBlock:(void (^)(NSArray *sortedGenres, NSString *errorMessage, BOOL completed))completionBlock;

@end

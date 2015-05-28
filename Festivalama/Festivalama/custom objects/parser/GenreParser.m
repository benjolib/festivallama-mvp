//
//  GenreParser.m
//  Festivalama
//
//  Created by Sztanyi Szabolcs on 28/05/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#import "GenreParser.h"
#import "Genre.h"

@implementation GenreParser

- (NSArray*)parseJSONData:(NSData*)data
{
    NSError *jsonError = nil;
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];
    NSArray *jsonArray = jsonDictionary[@"data"];
    if (jsonArray.count > 0)
    {
        NSMutableArray *genresArray = [NSMutableArray array];
        for (int i = 0; i < jsonArray.count; i++) {
            [genresArray addObject:[Genre genreWithName:jsonArray[i]]];
        }

        return [genresArray sortedArrayWithOptions:NSSortStable usingComparator:^NSComparisonResult(id obj1, id obj2) {
            Genre *genre1 = (Genre*)obj1;
            Genre *genre2 = (Genre*)obj2;
            return [genre1.name compare:genre2.name];
        }];
    } else {
        return nil;
    }
}

@end

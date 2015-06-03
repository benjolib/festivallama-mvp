//
//  BandParser.m
//  Festivalama
//
//  Created by Sztanyi Szabolcs on 02/06/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#import "BandParser.h"
#import "Band.h"

@implementation BandParser

- (NSArray*)parseJSONData:(NSData*)data
{
    NSError *jsonError = nil;
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];
    NSArray *jsonArray = jsonDictionary[@"data"];
    if (jsonArray.count > 0)
    {
        NSMutableArray *bandsArray = [NSMutableArray array];
        for (int i = 0; i < jsonArray.count; i++) {
            [bandsArray addObject:[Band bandWithName:jsonArray[i]]];
        }

        return [bandsArray sortedArrayWithOptions:NSSortStable usingComparator:^NSComparisonResult(id obj1, id obj2) {
            Band *band1 = (Band*)obj1;
            Band *band2 = (Band*)obj2;
            return [band1.name compare:band2.name];
        }];
    } else {
        return nil;
    }
}

@end

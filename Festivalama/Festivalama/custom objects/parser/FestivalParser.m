//
//  FestivalParser.m
//  Festivalama
//
//  Created by Sztanyi Szabolcs on 02/06/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#import "FestivalParser.h"
#import "FestivalModel.h"

@implementation FestivalParser

- (NSArray*)parseJSONData:(NSData*)data
{
    NSError *jsonError = nil;
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];
    NSArray *jsonArray = jsonDictionary[@"data"];
    if (jsonArray.count > 0)
    {
        NSMutableArray *festivals = [NSMutableArray array];
        for (int i = 0; i < jsonArray.count; i++) {
            [festivals addObject:[FestivalModel festivalModelFromDictionary:jsonArray[i]]];
        }

        return festivals;
    } else {
        return nil;
    }
}

@end

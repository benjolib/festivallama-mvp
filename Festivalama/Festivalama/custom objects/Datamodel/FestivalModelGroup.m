//
//  FestivalModelGroup.m
//  Festivalama
//
//  Created by Sztanyi Szabolcs on 07/06/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#import "FestivalModelGroup.h"

@implementation FestivalModelGroup

- (NSString*)groupTitleString
{
    return [NSString stringWithFormat:@"%ld - %ld", (long)self.month, (long)self.year];
}

@end

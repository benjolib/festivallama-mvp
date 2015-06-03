//
//  Band.m
//  Festivalama
//
//  Created by Sztanyi Szabolcs on 02/06/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#import "Band.h"

@implementation Band

+ (Band*)bandWithName:(NSString*)name
{
    Band *band = [Band new];
    band.name = name;
    return band;
}

@end

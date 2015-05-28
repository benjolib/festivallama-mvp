//
//  Genre.m
//  Festivalama
//
//  Created by Sztanyi Szabolcs on 28/05/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#import "Genre.h"

@implementation Genre

+ (Genre*)genreWithName:(NSString*)name
{
    Genre *genre = [Genre new];
    genre.name = name;
    return genre;
}

- (NSString *)debugDescription
{
    return [NSString stringWithFormat:@"Genre: %@", self.name];
}

@end

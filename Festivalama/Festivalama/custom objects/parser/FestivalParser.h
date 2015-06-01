//
//  FestivalParser.h
//  Festivalama
//
//  Created by Sztanyi Szabolcs on 02/06/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FestivalParser : NSObject

- (NSArray*)parseJSONData:(NSData*)data;

@end

//
//  FestivalModelGroup.h
//  Festivalama
//
//  Created by Sztanyi Szabolcs on 07/06/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#import <Foundation/Foundation.h>

/// Group class of Festival Model objects to be able to display them grouped by date

@class FestivalModel;

@interface FestivalModelGroup : NSObject

@property (nonatomic, strong) NSArray *festivalsArray;
@property (nonatomic) NSInteger *month;
@property (nonatomic) NSInteger *year;

- (NSString*)groupTitleString;

@end

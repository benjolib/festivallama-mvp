//
//  FilterCountriesDatasource.h
//  Festivalama
//
//  Created by Sztanyi Szabolcs on 01/06/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface FilterCountriesDatasource : NSObject

- (NSArray *)countryNames;
- (UIImage*)flagIconAtIndex:(NSInteger)index;

- (NSString *)countryNameAtIndex:(NSInteger)index;

@end

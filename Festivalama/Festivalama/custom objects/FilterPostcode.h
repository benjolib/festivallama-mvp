//
//  FilterPostcode.h
//  Festivalama
//
//  Created by Szabolcs Sztanyi on 23/06/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FilterPostcode : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic) NSInteger valueToSend;

+ (FilterPostcode*)filterPostcodeWithTitle:(NSString*)title andValue:(NSInteger)value;

@end

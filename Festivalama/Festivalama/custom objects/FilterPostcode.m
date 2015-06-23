//
//  FilterPostcode.m
//  Festivalama
//
//  Created by Szabolcs Sztanyi on 23/06/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#import "FilterPostcode.h"

@implementation FilterPostcode

+ (FilterPostcode*)filterPostcodeWithTitle:(NSString*)title andValue:(NSInteger)value
{
    FilterPostcode *postCode = [[FilterPostcode alloc] init];
    postCode.title = title;
    postCode.valueToSend = value;
    return postCode;
}

@end

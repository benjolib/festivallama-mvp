//
//  OnboardingOption.m
//  Festivalama
//
//  Created by Sztanyi Szabolcs on 30/05/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#import "OnboardingOption.h"

@implementation OnboardingOption

+ (OnboardingOption*)optionWithTitle:(NSString*)title andIndex:(NSInteger)index
{
    OnboardingOption *option = [OnboardingOption new];
    option.title = title;
    option.optionIndex = index;
    return option;
}

@end

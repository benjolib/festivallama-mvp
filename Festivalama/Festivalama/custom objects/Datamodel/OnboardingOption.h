//
//  OnboardingOption.h
//  Festivalama
//
//  Created by Sztanyi Szabolcs on 30/05/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OnboardingOption : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic) NSInteger optionIndex;

+ (OnboardingOption*)optionWithTitle:(NSString*)title andIndex:(NSInteger)index;

@end

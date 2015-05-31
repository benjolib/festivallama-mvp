//
//  OnboardingModel.m
//  Festivalama
//
//  Created by Sztanyi Szabolcs on 30/05/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#import "OnboardingModel.h"
#import "OnboardingOption.h"

@interface OnboardingModel ()
@property (nonatomic, strong, readwrite) NSMutableArray *travelOptionsArray;
@property (nonatomic, strong, readwrite) NSMutableArray *friendsCountArray;
@property (nonatomic, strong, readwrite) NSMutableArray *overnightArray;
@end

@implementation OnboardingModel

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.travelOptionsArray = [NSMutableArray array];
        self.friendsCountArray = [NSMutableArray array];
        self.overnightArray = [NSMutableArray array];

        [self fillDefaultValues];
    }
    return self;
}

- (void)fillDefaultValues
{
    NSArray *travelTitles = @[@"Selbe Stadt", @"Ganz Deutschland", @"Ganz Europa", @"Weltweit", @"Bin dabei, egal wohin"];
    [self fillArray:self.travelOptionsArray withItems:travelTitles];

    NSArray *accompanyTitles = @[@"Zu zweit", @"3 bis 5 Freunde", @"5 bis 10 Freunde", @"Mehr als 10", @"Keine Ahnung"];
    [self fillArray:self.friendsCountArray withItems:accompanyTitles];

    NSArray *overnightTitles = @[@"Zelt", @"Auto", @"Unter freiem Himmel", @"Wellness Hotel", @"Gar nicht, 3 Tage wach"];
    [self fillArray:self.overnightArray withItems:overnightTitles];
}

- (void)fillArray:(NSMutableArray*)array withItems:(NSArray*)itemsArray
{
    for (int i = 0; i < itemsArray.count; i++) {
        OnboardingOption *option = [OnboardingOption optionWithTitle:itemsArray[i] andIndex:i];
        [array addObject:option];
    }
}

@end

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
@property (nonatomic, strong, readwrite) NSMutableArray *visitorOptionsArray;
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
        self.visitorOptionsArray = [NSMutableArray array];
        self.travelOptionsArray = [NSMutableArray array];
        self.friendsCountArray = [NSMutableArray array];
        self.overnightArray = [NSMutableArray array];

        [self fillDefaultValues];
    }
    return self;
}

- (void)fillDefaultValues
{
    NSArray *visitorTitles = @[@"500 bis 1.000", @"1.000 bis 5.000", @"5.000 bis 10.000", @"mehr als 10.000", @"Is mir eigentlich egal"];
    [self fillArray:self.visitorOptionsArray withItems:visitorTitles];

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

/// Return the array of options according to the index of the ViewController in the onboarding
- (NSArray*)onboardingOptionsArrayForIndex:(NSInteger)index
{
    switch (index) {
        case 0:
            return self.visitorOptionsArray;
            break;
        case 1:
            return self.travelOptionsArray;
            break;
        case 2:
            return self.friendsCountArray;
            break;
        case 3:
            return self.overnightArray;
            break;
        default:
            return nil;
            break;
    }
}

- (NSString*)onboardingViewTitleForIndex:(NSInteger)index
{
    switch (index) {
        case 0:
            return @"Wie viele Besucher sollten an dem Festival teilnehmen?";
            break;
        case 1:
            return @"Wie weit du für ein Festival reisen?";
            break;
        case 2:
            return @"Mit wem reist du an?";
            break;
        case 3:
            return @"Welche Übernachtung würdest du bevorzugen?";
            break;
        default:
            return nil;
            break;
    }
}

- (NSString*)onboardingBackgroundImageViewNameForIndex:(NSInteger)index
{
    switch (index) {
        case 0:
            return @"screen1";
            break;
        case 1:
            return @"screen2";
            break;
        case 2:
            return @"screen3";
            break;
        case 3:
            return @"screen4";
            break;
        case 4:
            return @"screen5";
            break;
        case 5:
            return @"screen6";
            break;
        default:
            return @"screen1";
            break;
    }
}

@end

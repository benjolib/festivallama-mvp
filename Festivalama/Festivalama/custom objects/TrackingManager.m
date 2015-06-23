//
//  TrackingManager.m
//  Festivalama
//
//  Created by Sztanyi Szabolcs on 22/06/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#import "TrackingManager.h"
#import "Adjust.h"

@interface TrackingManager ()

@end

@implementation TrackingManager

+ (instancetype)sharedManager
{
    static TrackingManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupAdjustTracker];
        [self setupGATracker];
    }
    return self;
}

#pragma mark - GA tracking
- (void)setupGATracker
{

}

#pragma mark - adjustTracking
- (void)setupAdjustTracker
{
    NSString *yourAppToken = @"r8w2etf3abum";
    NSString *environment;
#ifdef DEBUG
    environment = ADJEnvironmentSandbox;
#else
    environment = ADJEnvironmentProduction;
#endif
    ADJConfig *adjustConfig = [ADJConfig configWithAppToken:yourAppToken
                                                environment:environment];
    [Adjust appDidLaunch:adjustConfig];
    [adjustConfig setLogLevel:ADJLogLevelDebug];
}

- (void)trackEventWithToken:(NSString*)token
{
    ADJEvent *event = [ADJEvent eventWithEventToken:token];
    [Adjust trackEvent:event];
}

- (void)trackUserLaunchedApp
{
    [self trackEventWithToken:@"wia0qi"];
}

- (void)trackUserSelectedFestivals
{
    [self trackEventWithToken:@"fs9qnr"];
}

- (void)trackUserSelectedPopularFestivals
{
    [self trackEventWithToken:@"czfvd5"];
}

- (void)trackUserSelectedCalender
{
    [self trackEventWithToken:@"rau1vg"];
}

- (void)trackUserSelectedInfo
{
    [self trackEventWithToken:@"l8fby8"];
}

- (void)trackUserSelectedMenu
{
    [self trackEventWithToken:@"yikvud"];
}

- (void)trackOpenFilterView
{
    [self trackEventWithToken:@"ozdtys"];
}

- (void)trackOpenSearch
{
    [self trackEventWithToken:@"r3v817"];
}

- (void)trackSelectsFestival
{
    [self trackEventWithToken:@"7d760b"];
}

- (void)trackUserAddedFestival
{
    [self trackEventWithToken:@"avevu0"];
}

- (void)trackUserRemovedFestival
{
    [self trackEventWithToken:@"qp8iqg"];
}

// filters
- (void)trackFilterSelectsGenreView
{
    [self trackEventWithToken:@"tjk5kl"];
}

- (void)trackFilterSelectsBandsView
{
    [self trackEventWithToken:@"qpfgmo"];
}

- (void)trackFilterSelectsPlaceView
{
    [self trackEventWithToken:@"a3s37i"];
}

- (void)trackFilterBackbutton
{
    [self trackEventWithToken:@"vwoyr4"];
}

- (void)trackFilterSelectsFilterButtonWithoutFilters
{
    [self trackEventWithToken:@"l7aud1"];
}

- (void)trackFilterSelectsFilterButtonWithFilters
{
    [self trackEventWithToken:@"rvji5s"];
}

- (void)trackFilterTapsTrashIconDetail
{
    [self trackEventWithToken:@"4ibpjl"];
}

- (void)trackFilterTapsTrashIconOnMainBandCell
{
    [self trackEventWithToken:@"8vwxm8"];
}

- (void)trackFilterTapsTrashIconMain
{
    [self trackEventWithToken:@"14xkds"];
}

- (void)trackFilterSelectsGenre
{
    [self trackEventWithToken:@"2z4ox4"];
}

- (void)trackFilterSelectsGenreAgainToUnselect
{
    [self trackEventWithToken:@"mmttag"];
}

- (void)trackFilterSearches
{
    [self trackEventWithToken:@"3jvsjf"];
}

- (void)trackFilterSelectsBand
{
    [self trackEventWithToken:@"t2hcvk"];
}

- (void)trackFilterSelectsBandAgainToUnselect
{
    [self trackEventWithToken:@"2wgocj"];
}

- (void)trackFilterSelectsPostcodeView
{
    [self trackEventWithToken:@"8za3dj"];
}

- (void)trackFilterSelectsCountryView
{
    [self trackEventWithToken:@"vuj0d2"];
}

- (void)trackFilterSelectsPostcode
{
    [self trackEventWithToken:@"oh6q3z"];
}

- (void)trackFilterSelectsCountry
{
    [self trackEventWithToken:@"6z5ti1"];
}

- (void)trackFilterSelectsCountryAgainToUnselect
{
    [self trackEventWithToken:@"mnq5qr"];
}

- (void)trackUserRemovesFestivalFromCalendar
{
    [self trackEventWithToken:@"8jb0pg"];
}


// festival details
- (void)trackUserSelectsTicketShop
{
    [self trackEventWithToken:@"c7gkpl"];
}

- (void)trackUserSelectsShareButton
{
    [self trackEventWithToken:@"wyr34a"];
}

- (void)trackUserSelectsWebsiteButton
{
    [self trackEventWithToken:@"xsnp65"];
}

- (void)trackUserSendsAnfrage
{
    [self trackEventWithToken:@"40ivz1"];
}

// info
- (void)trackUserSelectsWasWirMachen
{
    [self trackEventWithToken:@"tn1cyz"];
}

- (void)trackUserSelectsTeileDieApp
{
    [self trackEventWithToken:@"yx3y74"];
}

- (void)trackUserSelectsBewerteDieApp
{
    [self trackEventWithToken:@"s9hjjp"];
}

// popup
- (void)trackUserSelectsReviewApp
{
    [self trackEventWithToken:@"p1g6at"];
}

- (void)trackUserSelectsReviewAppLater
{
    [self trackEventWithToken:@"6rfv64"];
}

@end

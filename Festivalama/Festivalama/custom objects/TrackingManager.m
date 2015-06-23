//
//  TrackingManager.m
//  Festivalama
//
//  Created by Sztanyi Szabolcs on 22/06/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#import "TrackingManager.h"
#import "Adjust.h"
#import "GAI.h"
#import "GAIDictionaryBuilder.h"

@interface TrackingManager ()
@property(nonatomic, strong) id<GAITracker> tracker;
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
    // Optional: automatically send uncaught exceptions to Google Analytics.
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    
    // Optional: set Google Analytics dispatch interval to e.g. 20 seconds.
    [GAI sharedInstance].dispatchInterval = 40;
    
#ifdef DEBUG
    [[[GAI sharedInstance] logger] setLogLevel:kGAILogLevelInfo];
#endif
    
    // Initialize tracker. Replace with your tracking ID.
    [[GAI sharedInstance] trackerWithTrackingId:@"UA-62788448-4"];
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
    
    [self.tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                               action:@"launch"
                                                                label:@"userLaunchedApp"
                                                                value:nil] build]];
}

- (void)trackUserSelectedFestivals
{
    [self trackEventWithToken:@"fs9qnr"];

    [self.tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                               action:@"touch"
                                                                label:@"selects_festival_screen"
                                                                value:nil] build]];
}

- (void)trackUserSelectedPopularFestivals
{
    [self trackEventWithToken:@"czfvd5"];

    [self.tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                               action:@"touch"
                                                                label:@"selects_popular_festival_screen"
                                                                value:nil] build]];
}

- (void)trackUserSelectedCalender
{
    [self trackEventWithToken:@"rau1vg"];
    
    [self.tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                               action:@"touch"
                                                                label:@"selects_calendar_screen"
                                                                value:nil] build]];
}

- (void)trackUserSelectedInfo
{
    [self trackEventWithToken:@"l8fby8"];
    
    [self.tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                               action:@"touch"
                                                                label:@"selects_info_screen"
                                                                value:nil] build]];
}

- (void)trackUserSelectedMenu
{
    [self trackEventWithToken:@"yikvud"];
    
    [self.tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                               action:@"touch"
                                                                label:@"selects_menu_screen"
                                                                value:nil] build]];
}

- (void)trackOpenFilterView
{
    [self trackEventWithToken:@"ozdtys"];

    [self.tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                               action:@"touch"
                                                                label:@"selects_filter_screen"
                                                                value:nil] build]];
}

- (void)trackOpenSearch
{
    [self trackEventWithToken:@"r3v817"];
    
    [self.tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                               action:@"touch"
                                                                label:@"open_search"
                                                                value:nil] build]];
}

- (void)trackSelectsFestival
{
    [self trackEventWithToken:@"7d760b"];
    
    [self.tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                               action:@"button_tap"
                                                                label:@"selects_festival"
                                                                value:nil] build]];
}

- (void)trackUserAddedFestival
{
    [self trackEventWithToken:@"avevu0"];
    
    [self.tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                               action:@"button_tap"
                                                                label:@"added_festival"
                                                                value:nil] build]];
}

- (void)trackUserRemovedFestival
{
    [self trackEventWithToken:@"qp8iqg"];
    
    [self.tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                               action:@"button_tap"
                                                                label:@"removed_festival"
                                                                value:nil] build]];
}

// filters
- (void)trackFilterSelectsGenreView
{
    [self trackEventWithToken:@"tjk5kl"];
    
    [self.tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                               action:@"touch"
                                                                label:@"opens_filter_genre_view"
                                                                value:nil] build]];
}

- (void)trackFilterSelectsBandsView
{
    [self trackEventWithToken:@"qpfgmo"];

    [self.tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                               action:@"touch"
                                                                label:@"opens_filter_bands_view"
                                                                value:nil] build]];
}

- (void)trackFilterSelectsPlaceView
{
    [self trackEventWithToken:@"a3s37i"];
    
    [self.tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                               action:@"touch"
                                                                label:@"opens_filter_places_view"
                                                                value:nil] build]];
}

- (void)trackFilterBackbutton
{
    [self trackEventWithToken:@"vwoyr4"];
    
    [self.tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                               action:@"button_tap"
                                                                label:@"tapped_filter_back_button"
                                                                value:nil] build]];
}

- (void)trackFilterSelectsFilterButtonWithoutFilters
{
    [self trackEventWithToken:@"l7aud1"];

    [self.tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                               action:@"button_tap"
                                                                label:@"tapped_filterButton_withoutFilters"
                                                                value:nil] build]];
}

- (void)trackFilterSelectsFilterButtonWithFilters
{
    [self trackEventWithToken:@"rvji5s"];

    [self.tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                               action:@"button_tap"
                                                                label:@"tapped_filterButton_withFilters"
                                                                value:nil] build]];
}

- (void)trackFilterTapsTrashIconDetail
{
    [self trackEventWithToken:@"4ibpjl"];
    
    [self.tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                               action:@"button_tap"
                                                                label:@"filter_trashTapped_in_detail_view"
                                                                value:nil] build]];
}

- (void)trackFilterTapsTrashIconOnMainBandCell
{
    [self trackEventWithToken:@"8vwxm8"];

    [self.tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                               action:@"button_tap"
                                                                label:@"filter_trashTapped_on_band_cell"
                                                                value:nil] build]];
}

- (void)trackFilterTapsTrashIconMain
{
    [self trackEventWithToken:@"14xkds"];

    [self.tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                               action:@"button_tap"
                                                                label:@"filter_trashTapped_on_main_view"
                                                                value:nil] build]];
}

- (void)trackFilterSelectsGenre
{
    [self trackEventWithToken:@"2z4ox4"];
    
    [self.tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                               action:@"touch"
                                                                label:@"filter_selects_genre"
                                                                value:nil] build]];
}

- (void)trackFilterSelectsGenreAgainToUnselect
{
    [self trackEventWithToken:@"mmttag"];

    [self.tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                               action:@"touch"
                                                                label:@"filter_unSelects_genre"
                                                                value:nil] build]];
}

- (void)trackFilterSearches
{
    [self trackEventWithToken:@"3jvsjf"];

    [self.tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                               action:@"touch"
                                                                label:@"filter_search"
                                                                value:nil] build]];
}

- (void)trackFilterSelectsBand
{
    [self trackEventWithToken:@"t2hcvk"];

    [self.tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                               action:@"touch"
                                                                label:@"filter_selects_band"
                                                                value:nil] build]];
}

- (void)trackFilterSelectsBandAgainToUnselect
{
    [self trackEventWithToken:@"2wgocj"];
    
    [self.tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                               action:@"touch"
                                                                label:@"filter_UnSelects_band"
                                                                value:nil] build]];
}

- (void)trackFilterSelectsPostcodeView
{
    [self trackEventWithToken:@"8za3dj"];
    
    [self.tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                               action:@"touch"
                                                                label:@"opens_filter_postcode_view"
                                                                value:nil] build]];
}

- (void)trackFilterSelectsCountryView
{
    [self trackEventWithToken:@"vuj0d2"];
    
    [self.tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                               action:@"touch"
                                                                label:@"opens_filter_country_view"
                                                                value:nil] build]];
}

- (void)trackFilterSelectsPostcode
{
    [self trackEventWithToken:@"oh6q3z"];
    
    [self.tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                               action:@"touch"
                                                                label:@"filter_selects_postcode"
                                                                value:nil] build]];
}

- (void)trackFilterSelectsCountry
{
    [self trackEventWithToken:@"6z5ti1"];
    
    [self.tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                               action:@"touch"
                                                                label:@"filter_selects_country"
                                                                value:nil] build]];
}

- (void)trackFilterSelectsCountryAgainToUnselect
{
    [self trackEventWithToken:@"mnq5qr"];

    [self.tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                               action:@"touch"
                                                                label:@"filter_UnSelects_country"
                                                                value:nil] build]];
}

- (void)trackUserRemovesFestivalFromCalendar
{
    [self trackEventWithToken:@"8jb0pg"];
    
    [self.tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                               action:@"button_tap"
                                                                label:@"removes_festival_from_calendar"
                                                                value:nil] build]];
}


// festival details
- (void)trackUserSelectsTicketShop
{
    [self trackEventWithToken:@"c7gkpl"];
    
    [self.tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                               action:@"touch"
                                                                label:@"selects_ticketShop_screen"
                                                                value:nil] build]];
}

- (void)trackUserSelectsShareButton
{
    [self trackEventWithToken:@"wyr34a"];
    
    [self.tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                               action:@"button_tap"
                                                                label:@"selects_share_button_onFestival"
                                                                value:nil] build]];
}

- (void)trackUserSelectsWebsiteButton
{
    [self trackEventWithToken:@"xsnp65"];

    [self.tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                               action:@"button_tap"
                                                                label:@"selects_website_button"
                                                                value:nil] build]];
}

- (void)trackUserSendsAnfrage
{
    [self trackEventWithToken:@"40ivz1"];
    
    [self.tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                               action:@"button_tap"
                                                                label:@"selects_sends_anfrage"
                                                                value:nil] build]];
}

// info
- (void)trackUserSelectsWasWirMachen
{
    [self trackEventWithToken:@"tn1cyz"];
    
    [self.tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                               action:@"touch"
                                                                label:@"selects_wasWirMachen_screen"
                                                                value:nil] build]];
}

- (void)trackUserSelectsTeileDieApp
{
    [self trackEventWithToken:@"yx3y74"];
    
    [self.tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                               action:@"touch"
                                                                label:@"selects_TeileDieApp"
                                                                value:nil] build]];
}

- (void)trackUserSelectsBewerteDieApp
{
    [self trackEventWithToken:@"s9hjjp"];
    
    [self.tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                               action:@"touch"
                                                                label:@"selects_bewerteDieApp"
                                                                value:nil] build]];
}

// popup
- (void)trackUserSelectsReviewApp
{
    [self trackEventWithToken:@"p1g6at"];
    
    [self.tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                               action:@"touch"
                                                                label:@"selects_reviewAppPopup"
                                                                value:nil] build]];
}

- (void)trackUserSelectsReviewAppLater
{
    [self trackEventWithToken:@"6rfv64"];
    [self.tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                               action:@"touch"
                                                                label:@"selects_reviewAppLaterPopup"
                                                                value:nil] build]];
}

@end

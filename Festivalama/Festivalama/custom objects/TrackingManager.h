//
//  TrackingManager.h
//  Festivalama
//
//  Created by Sztanyi Szabolcs on 22/06/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TrackingManager : NSObject

+ (instancetype)sharedManager;

// adjust
- (void)trackUserLaunchedApp;
- (void)trackUserSelectedFestivals;
- (void)trackUserSelectedPopularFestivals;
- (void)trackUserSelectedCalender;
- (void)trackUserSelectedInfo;
- (void)trackUserSelectedMenu;
- (void)trackOpenFilterView;
- (void)trackOpenSearch;
- (void)trackSelectsFestival;
- (void)trackUserAddedFestival;
- (void)trackUserRemovedFestival;

// filters
- (void)trackFilterSelectsGenreView;
- (void)trackFilterSelectsBandsView;
- (void)trackFilterSelectsPlaceView;
- (void)trackFilterBackbutton;
- (void)trackFilterSelectsFilterButtonWithoutFilters;
- (void)trackFilterSelectsFilterButtonWithFilters;
- (void)trackFilterTapsTrashIconDetail;
- (void)trackFilterTapsTrashIconOnMainBandCell;
- (void)trackFilterTapsTrashIconMain;
- (void)trackFilterSelectsGenre;
- (void)trackFilterSelectsGenreAgainToUnselect;
- (void)trackFilterSearches;
- (void)trackFilterSelectsBand;
- (void)trackFilterSelectsBandAgainToUnselect;
- (void)trackFilterSelectsPostcodeView;
- (void)trackFilterSelectsCountryView;
- (void)trackFilterSelectsPostcode;
- (void)trackFilterSelectsCountry;
- (void)trackFilterSelectsCountryAgainToUnselect;
- (void)trackUserRemovesFestivalFromCalendar;

// festival details
- (void)trackUserSelectsTicketShop;
- (void)trackUserSelectsShareButton;
- (void)trackUserSelectsWebsiteButton;
- (void)trackUserSendsAnfrage;

// info
- (void)trackUserSelectsWasWirMachen;
- (void)trackUserSelectsTeileDieApp;
- (void)trackUserSelectsBewerteDieApp;

// popup
- (void)trackUserSelectsReviewApp;
- (void)trackUserSelectsReviewAppLater;

@end

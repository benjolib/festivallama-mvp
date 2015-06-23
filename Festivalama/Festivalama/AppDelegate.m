//
//  AppDelegate.m
//  Festivalama
//
//  Created by Sztanyi Szabolcs on 28/05/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#import "AppDelegate.h"
#import "GeneralSettings.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#import <StoreKit/StoreKit.h>
#import "Reachability.h"
#import "PopupView.h"
#import "CoreDataHandler.h"
#import "TrackingManager.h"

#define IS_iOS8 [[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0

@interface AppDelegate () <PopupViewDelegate, SKStoreProductViewControllerDelegate>
@property (nonatomic, strong) Reachability *internetReachable;
@property (nonatomic, strong) PopupView *noInternetPopup;
@property (nonatomic, strong) PopupView *onTrackPopup;
@property (nonatomic, strong) PopupView *reviewInAppStorePopup;

@property (nonatomic, strong) UILabel *debugLabel;
@property (nonatomic, strong) NSTimer *popupDisplayerTimer;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [Fabric with:@[CrashlyticsKit]];
    [self addNetworkObserver];

    UIViewController *vc = nil;
    if ([GeneralSettings onboardingViewed]) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        vc = [storyboard instantiateInitialViewController];
    } else {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Onboarding" bundle:[NSBundle mainBundle]];
        vc = [storyboard instantiateInitialViewController];
    }

    // Set root view controller and make windows visible
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = vc;
    [self.window makeKeyAndVisible];

#if DEBUG
    self.debugLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 50.0, 14.0)];
    self.debugLabel.text = @" DEBUG";
    self.debugLabel.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.2];
    self.debugLabel.textColor = [UIColor colorWithWhite:1.0 alpha:0.6];
    self.debugLabel.font = [UIFont systemFontOfSize:12.0];
    [self.window addSubview:self.debugLabel];
#endif

    [[TrackingManager sharedManager] trackUserLaunchedApp];
    return YES;
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [[CoreDataHandler sharedHandler] saveMasterContext];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{

}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{

}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{

}

#pragma mark - popup view handling
- (void)checkToDisplayOnTrackPopup
{
    if ([GeneralSettings passedIntervalSinceAppStart] > (2 * 60) && ![GeneralSettings wasOnTrackPromptShown]) {
        [self displayOnTrackPopup];
    } else if ([GeneralSettings passedIntervalSinceAppStart] > (5 * 60) && ![GeneralSettings wasRateAppShown]) {
        [self displayAppStoreReviewPopup];
        [self.popupDisplayerTimer invalidate];
        self.popupDisplayerTimer = nil;
    }
}

- (void)startPopupTimer
{
    if ([GeneralSettings wasOnTrackPromptShown] || [GeneralSettings wasRateAppShown]) {
        return;
    }
    self.popupDisplayerTimer = [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(updatePopupTimer:) userInfo:nil repeats:YES];
}

- (void)stopPopupTimer
{
    [self.popupDisplayerTimer invalidate];
    self.popupDisplayerTimer = nil;
}

- (void)updatePopupTimer:(NSTimer*)timer
{
    [self checkToDisplayOnTrackPopup];
}

- (void)displayOnTrackPopup
{
    if (self.onTrackPopup.superview) {
        return;
    }
    self.onTrackPopup = [[PopupView alloc] initWithDelegate:self];
    [self.onTrackPopup setupWithConfirmButtonTitle:@"Klar, warum nicht"
                                 cancelButtonTitle:nil
                                         viewTitle:@"On Track"
                                              text:@"Sicher Dir die Möglichkeit an geschlossenen Vorverkaufs Aktionen teilzunehmen."
                                              icon:[UIImage imageNamed:@"iconOnTrack"]];
    [self.onTrackPopup showPopupViewAnimationOnView:self.window withBlurredBackground:YES];
    [GeneralSettings setOnTrackPromptWasShown];
}

- (void)displayAppStoreReviewPopup
{
    if (self.reviewInAppStorePopup.superview) {
        return;
    }
    self.reviewInAppStorePopup = [[PopupView alloc] initWithDelegate:self];
    [self.reviewInAppStorePopup setupWithConfirmButtonTitle:@"Klar, warum nicht"
                                          cancelButtonTitle:@"Vielleicht später"
                                                  viewTitle:@"Deine ideen"
                                                       text:@"Hast Du Ideen was man an der App verbessern könnte? Wir würden Sie gerne hören. Über den App Store kannst Du uns Deinen Kommentar hinterlassen"
                                                       icon:[UIImage imageNamed:@"iconStar"]];
    [self.reviewInAppStorePopup showPopupViewAnimationOnView:self.window withBlurredBackground:YES];
    [GeneralSettings setRateAppWasShown];
}

#pragma mark - internet connection checking methods
- (void)addNetworkObserver
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkStatusChanged:) name:kReachabilityChangedNotification object:nil];
    self.internetReachable = [Reachability reachabilityForInternetConnection];
    [self.internetReachable startNotifier];
}

- (void)networkStatusChanged:(NSNotification*)notification
{
    NetworkStatus status = [self.internetReachable currentReachabilityStatus];
    switch (status) {
        case NotReachable:
            [self showNoInternetPopup];
            break;
        case ReachableViaWiFi:
        case ReachableViaWWAN:
        default:
            [self hideNoInternetPopup];
            break;
    }
}

- (void)showNoInternetPopup
{
    if (self.noInternetPopup.superview) {
        return;
    }
    self.noInternetPopup = [[PopupView alloc] initWithDelegate:self];
    [self.noInternetPopup setupWithConfirmButtonTitle:@"Erneut versuchen"
                                 cancelButtonTitle:nil
                                         viewTitle:@"Sorry"
                                              text:@"Es scheint als hättest Du derzeit keine Verbindung zum Internet."
                                              icon:[UIImage imageNamed:@"iconWifi"]];
    [self.noInternetPopup showPopupViewAnimationOnView:self.window withBlurredBackground:YES];
}

- (void)hideNoInternetPopup
{
    [self.noInternetPopup dismissViewWithAnimation:YES];
    self.noInternetPopup = nil;
}

- (void)popupViewConfirmButtonPressed:(PopupView *)popupView
{
    if (popupView == self.onTrackPopup) {
        if (IS_iOS8) {
            [[UIApplication sharedApplication] registerForRemoteNotifications];
        } else {
            [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeSound];
        }
    } else if (popupView == self.reviewInAppStorePopup) {
        [[TrackingManager sharedManager] trackUserSelectsReviewApp];
        [self rateTheApp];
    }
    [popupView dismissViewWithAnimation:YES];
    popupView = nil;

    if ([self.internetReachable currentReachabilityStatus] == NotReachable) {
        [self showNoInternetPopup];
    }
}

- (void)popupViewCancelButtonPressed:(PopupView *)popupView
{
    if (popupView == self.reviewInAppStorePopup) {
        [self stopPopupTimer];
        [GeneralSettings saveAppStartDate];
        [[TrackingManager sharedManager] trackUserSelectsReviewAppLater];
    }
    [popupView dismissViewWithAnimation:YES];
    popupView = nil;
}

#pragma mark - rating the app
- (void)rateTheApp
{
    SKStoreProductViewController *storeProductViewController = [[SKStoreProductViewController alloc] init];
    [storeProductViewController setDelegate:self];

    // TODO: needs App id
    [storeProductViewController loadProductWithParameters:@{SKStoreProductParameterITunesItemIdentifier : @"0"} completionBlock:^(BOOL result, NSError *error) {
        if (error) {
            NSLog(@"Error %@ with User Info %@.", error, [error userInfo]);
        } else {
            // Present Store Product View Controller
            [self.window.rootViewController presentViewController:storeProductViewController animated:YES completion:nil];
        }
    }];
}

- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController
{
    [viewController dismissViewControllerAnimated:YES completion:nil];
}

@end

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
#import "Reachability.h"
#import "PopupView.h"
#import "CoreDataHandler.h"

@interface AppDelegate () <PopupViewDelegate>
@property (nonatomic, strong) Reachability *internetReachable;
@property (nonatomic, strong) PopupView *noInternetPopup;
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
    return YES;
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [[CoreDataHandler sharedHandler] saveMasterContext];
}

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

- (void)popupViewConfirmButtonPressed
{
    [self.noInternetPopup dismissViewWithAnimation:YES];
    self.noInternetPopup = nil;

    if ([self.internetReachable currentReachabilityStatus] == NotReachable) {
        [self showNoInternetPopup];
    }
}

@end

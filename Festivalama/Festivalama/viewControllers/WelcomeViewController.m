//
//  WelcomeViewController.m
//  Festivalama
//
//  Created by Sztanyi Szabolcs on 28/05/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#import "WelcomeViewController.h"
#import "PopupView.h"
#import <AVFoundation/AVFoundation.h>
#import "GenreDownloadClient.h"
#import "QuestionsContainerViewController.h"
#import "LocationManager.h"


#import "MenuTransitionManager.h"
#import "StoryboardManager.h"
#import "FilterNavigationController.h"
#import "FestivalNavigationController.h"

@interface WelcomeViewController () <PopupViewDelegate>
@property (nonatomic, strong) PopupView *activePopup;
@property (nonatomic, strong) AVPlayerLayer *playerLayer;
@property (nonatomic) BOOL firstPopupWasDisplayed;

@property (nonatomic, strong) LocationManager *locationManager;
@property (nonatomic, strong) GenreDownloadClient *genreDownloadClient;
@property (nonatomic, strong) NSArray *genresArray;
@property (nonatomic, strong) MenuTransitionManager *transitionManager;
@end

@implementation WelcomeViewController

- (IBAction)showMenu:(id)sender
{
    self.transitionManager = [MenuTransitionManager new];
    [self.transitionManager presentMenuViewControllerOnViewController:self];
}

- (IBAction)showHome:(id)sender
{
    FestivalNavigationController *festivalsNavC = [StoryboardManager festivalNavigationController];
    [self presentViewController:festivalsNavC animated:YES completion:nil];
}

- (IBAction)showFilterView:(id)sender
{
    FilterNavigationController *filterNav = [StoryboardManager filterNavigationController];
    [self presentViewController:filterNav animated:YES completion:nil];
}

- (void)displayFirstPopup
{
    self.activePopup = [[PopupView alloc] initWithDelegate:self];
    [self.activePopup setupWithConfirmButtonTitle:@"Los geht's!"
                                cancelButtonTitle:nil
                                        viewTitle:@"Vergiss den Alltag"
                                             text:@"Und tauche ein in den Festival Sommer Deines Lebens. Mit 5 Fragen erstellen wir Dir Deinen individuellen Festival-Kalender."
                                             icon:[UIImage imageNamed:@""]];
    [self.activePopup showPopupViewAnimationOnView:self.view];
}

- (void)displaySecondPopup
{
    self.activePopup = [[PopupView alloc] initWithDelegate:self];
    [self.activePopup setupWithConfirmButtonTitle:@"Location teilen"
                                cancelButtonTitle:nil
                                        viewTitle:@"Location"
                                             text:@"Du möchtest wissen, welche Festivals in Deiner Nähe stattfinden?"
                                             icon:[UIImage imageNamed:@"iconLocation"]];
    [self.activePopup showPopupViewAnimationOnView:self.view];
}

- (void)downloadGenres
{
    self.genreDownloadClient = [GenreDownloadClient new];

    __weak typeof(self) weakSelf = self;
    [self.genreDownloadClient downloadAllGenresWithCompletionBlock:^(NSArray *sortedGenres, NSString *errorMessage, BOOL completed) {
        if (completed) {
            weakSelf.genresArray = [sortedGenres copy];
        } else {

        }
    }];
}

#pragma mark - popup methods
- (void)popupViewConfirmButtonPressed
{
    if (!self.firstPopupWasDisplayed) {
        self.firstPopupWasDisplayed = YES;
        [self.activePopup dismissViewWithAnimation:YES];

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self displaySecondPopup];
        });
    } else {
        [self.activePopup dismissViewWithAnimation:YES];
        // show location popup, if agreed go on

        self.locationManager = [LocationManager new];
        [self.locationManager startLocationDiscoveryWithCompletionBlock:^(CLLocation *userLocation, NSString *errorMessage) {
            if (userLocation) {
                [self.locationManager stopLocationDiscovery];
                [self performSegueWithIdentifier:@"presentOnboarding" sender:nil];
            }
        }];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"presentOnboarding"]) {
        QuestionsContainerViewController *questionsViewController = (QuestionsContainerViewController*)segue.destinationViewController;
        questionsViewController.genresArray = [self.genresArray copy];
    }
}

#pragma mark - background video methods
- (AVPlayerLayer*)playerLayer
{
    if (!_playerLayer) {
        NSString *moviePath = [[NSBundle mainBundle] pathForResource:@"arenaVideo" ofType:@"mp4"];
        NSURL *movieURL = [NSURL fileURLWithPath:moviePath];
        _playerLayer = [AVPlayerLayer playerLayerWithPlayer:[[AVPlayer alloc] initWithURL:movieURL]];
        _playerLayer.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
        [_playerLayer.player play];
        return _playerLayer;
    }
    return _playerLayer;
}

- (void)replayMovie:(NSNotification *)notification
{
    [self.playerLayer.player play];
}

- (void)addVideoBackgroundLayer
{
    [self.view.layer addSublayer:self.playerLayer];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(replayMovie:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:nil];
}

#pragma mark - view methods
- (void)viewDidLoad
{
    [super viewDidLoad];

//    [self addVideoBackgroundLayer];

    [self downloadGenres];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self displayFirstPopup];
    });
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

@end

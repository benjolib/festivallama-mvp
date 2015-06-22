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
#import "CategoryDownloadClient.h"
#import "QuestionsContainerViewController.h"
#import "LocationManager.h"

#import "StoryboardManager.h"

@interface WelcomeViewController () <PopupViewDelegate>
@property (nonatomic, strong) PopupView *activePopup;
@property (nonatomic, strong) AVPlayerLayer *playerLayer;
@property (nonatomic) BOOL firstPopupWasDisplayed;

@property (nonatomic, strong) LocationManager *locationManager;
@property (nonatomic, strong) CategoryDownloadClient *categoryDownloadClient;
@property (nonatomic, strong) NSArray *genresArray;
@end

@implementation WelcomeViewController

- (void)displayFirstPopup
{
    self.activePopup = [[PopupView alloc] initWithDelegate:self];
    [self.activePopup setupWithConfirmButtonTitle:@"Los geht's!"
                                cancelButtonTitle:nil
                                        viewTitle:@"Vergiss den Alltag"
                                             text:@"Und tauche ein in den Festival Sommer Deines Lebens. Mit 5 Fragen erstellen wir Dir Deinen individuellen Festival-Kalender."
                                             icon:[UIImage imageNamed:@"iconTent"]];
    [self.activePopup showPopupViewAnimationOnView:self.view withBlurredBackground:NO];
}

- (void)displaySecondPopup
{
    self.activePopup = [[PopupView alloc] initWithDelegate:self];
    [self.activePopup setupWithConfirmButtonTitle:@"Location teilen"
                                cancelButtonTitle:nil
                                        viewTitle:@"Location"
                                             text:@"Du möchtest wissen, welche Festivals in Deiner Nähe stattfinden?"
                                             icon:[UIImage imageNamed:@"iconLocation"]];
    [self.activePopup showPopupViewAnimationOnView:self.view withBlurredBackground:NO];
}

- (void)downloadGenres
{
    self.categoryDownloadClient = [CategoryDownloadClient new];

    __weak typeof(self) weakSelf = self;
    [self.categoryDownloadClient downloadAllCategoriesWithCompletionBlock:^(NSArray *sortedCategories, NSString *errorMessage, BOOL completed) {
        if (completed) {
            weakSelf.genresArray = [sortedCategories copy];
            [weakSelf performSegueWithIdentifier:@"presentOnboarding" sender:nil];
        } else {
            // TODO: error handling
        }
    }];
}

#pragma mark - popup methods
- (void)popupViewConfirmButtonPressed:(PopupView *)popupView
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
        NSString *moviePath = [[NSBundle mainBundle] pathForResource:@"festivalama_video" ofType:@"mov"];
        NSURL *movieURL = [NSURL fileURLWithPath:moviePath];
        AVPlayer *player = [[AVPlayer alloc] initWithURL:movieURL];
        player.rate = 0.6;
        _playerLayer = [AVPlayerLayer playerLayerWithPlayer:player];
        _playerLayer.frame = CGRectMake(-CGRectGetWidth(self.view.frame), -2.5*CGRectGetHeight(self.view.frame), CGRectGetWidth(self.view.frame) * 4, CGRectGetHeight(self.view.frame) * 6);
        [_playerLayer.player play];
        return _playerLayer;
    }
    return _playerLayer;
}

- (void)replayMovie:(NSNotification *)notification
{
    self.festivalamaImageView.alpha = 0.0;
    self.festivalamaImageView.transform = CGAffineTransformMakeScale(0.8, 0.8);
    [self.view bringSubviewToFront:self.festivalamaImageView];

    [UIView animateWithDuration:0.3 animations:^{
        self.festivalamaImageView.transform = CGAffineTransformIdentity;
        self.festivalamaImageView.alpha = 1.0;
    } completion:^(BOOL finished) {
        [self displayFirstPopup];
    }];
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

    self.festivalamaImageView.alpha = 0.0;
//    [self addVideoBackgroundLayer];

    [self downloadGenres];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

@end

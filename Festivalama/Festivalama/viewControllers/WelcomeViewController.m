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

@interface WelcomeViewController () <PopupViewDelegate>
@property (nonatomic, strong) PopupView *activePopup;
@property (nonatomic, strong) AVPlayerLayer *playerLayer;
@property (nonatomic) BOOL firstPopupWasDisplayed;
@end

@implementation WelcomeViewController

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
                                             icon:[UIImage imageNamed:@""]];
    [self.activePopup showPopupViewAnimationOnView:self.view];
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

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self displayFirstPopup];
    });
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

@end

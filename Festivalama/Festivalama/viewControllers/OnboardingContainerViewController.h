//
//  OnboardingContainerViewController.h
//  Festivalama
//
//  Created by Szabolcs Sztanyi on 24/06/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "OnboardingModel.h"

@class ContinueButton, OnboardingPageControlView;

@interface OnboardingContainerViewController : UIViewController <UIScrollViewDelegate>

@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) IBOutlet ContinueButton *continueButton;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *continueButtonHeightConstraint;
@property (nonatomic, weak) IBOutlet OnboardingPageControlView *pageControl;
@property (nonatomic, strong) NSArray *genresArray;
@property (nonatomic, strong) OnboardingModel *onboardingModel;
@property (nonatomic, strong) CLLocation *userLocation;

- (IBAction)moveToNextViewController:(id)sender;

- (void)showNextViewController;
- (void)setFilterByLocationEnabled:(BOOL)enabled;

@end

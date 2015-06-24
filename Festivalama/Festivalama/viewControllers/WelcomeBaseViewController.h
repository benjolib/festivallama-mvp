//
//  WelcomeBaseViewController.h
//  Festivalama
//
//  Created by Sztanyi Szabolcs on 03/06/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OnboardingContainerViewController.h"

// Base viewController for all the viewController in the onboarding section

@interface WelcomeBaseViewController : UIViewController

@property (nonatomic, strong) OnboardingContainerViewController *rootViewController;
@property (nonatomic) NSInteger indexOfView;

- (void)reloadSelection;

@end

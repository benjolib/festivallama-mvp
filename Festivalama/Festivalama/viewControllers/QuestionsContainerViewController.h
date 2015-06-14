//
//  QuestionsContainerViewController.h
//  Festivalama
//
//  Created by Sztanyi Szabolcs on 30/05/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OnboardingModel.h"

@interface QuestionsContainerViewController : UIViewController

@property (nonatomic, strong) NSArray *genresArray;
@property (nonatomic, strong) OnboardingModel *onboardingModel;

- (void)showNextViewController;
- (void)setFilterByLocationEnabled:(BOOL)enabled;

@end
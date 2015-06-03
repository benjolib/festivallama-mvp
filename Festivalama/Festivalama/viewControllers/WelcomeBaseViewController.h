//
//  WelcomeBaseViewController.h
//  Festivalama
//
//  Created by Sztanyi Szabolcs on 03/06/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuestionsContainerViewController.h"

// Base viewController for all the viewController in the onboarding section

@interface WelcomeBaseViewController : UIViewController <QuestionsContainerViewControllerChild>

@property (nonatomic, strong) QuestionsContainerViewController *rootViewController;

@end

//
//  MenuViewController.h
//  Festivalama
//
//  Created by Sztanyi Szabolcs on 31/05/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MenuButton;

@interface MenuViewController : UIViewController

@property (nonatomic, weak) IBOutlet MenuButton *festivalButton;
@property (nonatomic, weak) IBOutlet MenuButton *favoriteFestivalButton;
@property (nonatomic, weak) IBOutlet MenuButton *calendarButton;
@property (nonatomic, weak) IBOutlet UIButton *infoButton;

- (void)saveSourceViewController:(UIViewController*)sourceViewController;

@end

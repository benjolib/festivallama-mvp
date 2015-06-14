//
//  MainContainerViewController.h
//  Festivalama
//
//  Created by Sztanyi Szabolcs on 05/06/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSUInteger, MenuItem) {
    MenuItemFestivals,
    MenuItemFavoriteFestivals,
    MenuItemFestivalsCalendar,
};

@interface MainContainerViewController : UIViewController

@property (nonatomic, weak) IBOutlet UIView *containerView;
@property (nonatomic, weak) IBOutlet UIView *navigationView;

- (void)changeToMenuItem:(MenuItem)menuItem;

- (void)setParentTitle:(NSString*)title;

@end

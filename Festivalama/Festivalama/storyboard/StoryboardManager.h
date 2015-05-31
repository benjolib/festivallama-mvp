//
//  StoryboardManager.h
//  Festivalama
//
//  Created by Sztanyi Szabolcs on 28/05/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class MenuViewController;

@interface StoryboardManager : NSObject

+ (UIStoryboard*)mainStoryboard;

+ (MenuViewController*)menuViewController;

@end

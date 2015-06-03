//
//  QuestionsContainerViewController.h
//  Festivalama
//
//  Created by Sztanyi Szabolcs on 30/05/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuestionsContainerViewController : UIViewController

@property (nonatomic, strong) NSArray *genresArray;

- (void)showNextViewController;
- (void)setFilterByLocationEnabled:(BOOL)enabled;

@end

@protocol QuestionsContainerViewControllerChild <NSObject>

@property (nonatomic) NSInteger pageIndex;

@end
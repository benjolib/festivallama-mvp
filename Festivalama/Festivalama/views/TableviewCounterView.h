//
//  TableviewCounterView.h
//  Festivalama
//
//  Created by Sztanyi Szabolcs on 01/06/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#import <UIKit/UIKit.h>

/// UIView that is showing the number of items in the TableView

@interface TableviewCounterView : UIView

- (void)addToView:(UIView*)view;

- (void)setTitle:(NSString*)title;
- (void)displayTheNumberOfItems:(NSInteger)festivalCount;

- (void)setCounterViewVisible:(BOOL)visible animated:(BOOL)animated;

- (BOOL)hasTitle;

@end

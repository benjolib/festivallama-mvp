//
//  FilterViewController.h
//  Festivalama
//
//  Created by Sztanyi Szabolcs on 31/05/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FilterModel.h"

@class GreenButton;

@interface FilterViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet GreenButton *applyButton;
@property (nonatomic, weak) IBOutlet UIButton *trashIcon;

@property (nonatomic, strong, readonly) NSArray *genresArray;
@property (nonatomic, strong) FilterModel *filterModel;

- (IBAction)applyButtonPressed:(id)sender;
- (IBAction)trashButtonPressed:(id)sender;

- (void)setTrashIconVisible:(BOOL)visible;

@end

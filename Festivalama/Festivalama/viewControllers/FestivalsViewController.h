//
//  FestivalsViewController.h
//  Festivalama
//
//  Created by Sztanyi Szabolcs on 01/06/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#import "BaseGradientViewController.h"

@class FilterButton, LoadingTableView, FestivalRefreshControl, TableviewCounterView;

@interface FestivalsViewController : BaseGradientViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet LoadingTableView *tableView;
@property (nonatomic, weak) IBOutlet FilterButton *applyButton;
@property (nonatomic, weak) IBOutlet UIButton *trashIcon;

@property (nonatomic, strong) NSMutableArray *festivalsArray;
@property (nonatomic, strong) FestivalRefreshControl *refreshController;
@property (nonatomic, strong) TableviewCounterView *tableCounterView;
@property (nonatomic) BOOL showLoadingIndicatorCell;

- (IBAction)filterButtonPressed:(id)sender;
- (IBAction)trashButtonPressed:(id)sender;

- (void)prepareView;
- (void)downloadNextFestivals;
- (void)calenderButtonTapped:(UIButton*)button;

@end

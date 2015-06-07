//
//  FestivalsViewController.h
//  Festivalama
//
//  Created by Sztanyi Szabolcs on 01/06/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#import "BaseGradientViewController.h"

@class GreenButton, LoadingTableView;

@interface FestivalsViewController : BaseGradientViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet LoadingTableView *tableView;
@property (nonatomic, weak) IBOutlet GreenButton *applyButton;
@property (nonatomic, weak) IBOutlet UIButton *trashIcon;

@property (nonatomic, strong) NSMutableArray *festivalsArray;

- (IBAction)filterButtonPressed:(id)sender;
- (IBAction)trashButtonPressed:(id)sender;

@end

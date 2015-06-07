//
//  FestivalDetailBandsViewController.h
//  Festivalama
//
//  Created by Sztanyi Szabolcs on 07/06/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#import "BaseGradientViewController.h"

@class FestivalModel;

@interface FestivalDetailBandsViewController : BaseGradientViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) FestivalModel *festivalToDisplay;

@end

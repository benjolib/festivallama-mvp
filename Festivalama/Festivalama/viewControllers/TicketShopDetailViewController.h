//
//  TicketShopDetailViewController.h
//  Festivalama
//
//  Created by Sztanyi Szabolcs on 10/06/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#import "BaseGradientViewController.h"

@class FestivalModel, WhiteButton;

@interface TicketShopDetailViewController : BaseGradientViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet WhiteButton *sendButton;

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UIButton *leftButton;
@property (nonatomic, weak) IBOutlet UIView *navigationView;

@property (nonatomic, weak) FestivalModel *festivalToDisplay;

- (IBAction)sendButtonTapped:(id)sender;

@end

//
//  FilterViewController.h
//  Festivalama
//
//  Created by Sztanyi Szabolcs on 31/05/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#import "BaseGradientViewController.h"
#import "FilterModel.h"
#import "LoadingTableView.h"

@class GreenButton;

@interface FilterViewController : BaseGradientViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (nonatomic, weak) IBOutlet LoadingTableView *tableView;
@property (nonatomic, weak) IBOutlet GreenButton *applyButton;
@property (nonatomic, weak) IBOutlet UIButton *trashIcon;

@property (nonatomic, strong, readonly) NSArray *genresArray;
@property (nonatomic, strong) FilterModel *filterModel;

// search views
@property (nonatomic, weak) IBOutlet UIView *searchWrapperView;
@property (nonatomic, weak) IBOutlet UITextField *searchField;
@property (nonatomic, weak) IBOutlet UIButton *searchCancelButton;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *searchCancelButtonWidthConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *searchWrapperViewTrailingConstraint;

- (IBAction)applyButtonPressed:(id)sender;
- (IBAction)trashButtonPressed:(id)sender;

- (void)setTrashIconVisible:(BOOL)visible;
- (void)adjustButtonToFilterModel;

- (IBAction)backButtonPressed:(id)sender;

- (void)setupSearchView;
- (void)searchFieldTextChanged:(UITextField*)textfield;
- (IBAction)searchCancelButtonTapped:(id)sender;

@end

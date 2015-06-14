//
//  QuestionsViewController.h
//  Festivalama
//
//  Created by Sztanyi Szabolcs on 30/05/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#import "WelcomeBaseViewController.h"

@interface QuestionsViewController : WelcomeBaseViewController <UITableViewDataSource, UITableViewDelegate, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;

@property (nonatomic, strong) NSArray *optionsToDisplay;
@property (nonatomic, strong, readonly) NSMutableArray *selectedOptionsArray;

- (void)setViewTitle:(NSString*)title backgroundImage:(NSString*)imageName;

@end

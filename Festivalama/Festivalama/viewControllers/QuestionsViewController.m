//
//  QuestionsViewController.m
//  Festivalama
//
//  Created by Sztanyi Szabolcs on 30/05/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#import "QuestionsViewController.h"
#import "OnboardingOption.h"
#import "SelectionCollectionViewCell.h"
#import "SelectionTableViewCell.h"
#import "NSDictionary+nonNullObjectForKey.h"
#import "UIColor+AppColors.h"

static NSInteger cellHeight = 60.0;

@interface QuestionsViewController ()
@property (nonatomic, strong, readwrite) NSMutableArray *selectedOptionsArray;
@property (nonatomic, copy) NSString *titleString;
@property (nonatomic, copy) NSString *imageNameString;
@property (nonatomic, strong) OnboardingOption *selectedOption;
@end

@implementation QuestionsViewController

- (void)setViewTitle:(NSString*)title backgroundImage:(NSString*)imageName
{
    self.titleString = title;
    self.imageNameString = imageName;
}

#pragma mark - tableView methods
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SelectionTableViewCell *cell = (SelectionTableViewCell*)[tableView dequeueReusableCellWithIdentifier:[SelectionTableViewCell cellIdentifier]];

    OnboardingOption *option = self.optionsToDisplay[indexPath.section];
    cell.titleLabel.text = option.title;

    BOOL cellSelected = [option isEqual:self.selectedOption];
    if (cellSelected) {
        cell.selected = YES;
    }

    cell.backgroundColor = [UIColor clearColor];

    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.optionsToDisplay.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return cellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return (CGRectGetHeight(tableView.frame) / self.optionsToDisplay.count) - cellHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor clearColor];
    return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    OnboardingOption *option = self.optionsToDisplay[indexPath.section];

    if (!self.selectedOptionsArray) {
        self.selectedOptionsArray = [NSMutableArray array];
    }

    if ([self.selectedOptionsArray containsObject:option]) {
        [self.selectedOptionsArray removeObject:option];
    } else {
        [self.selectedOptionsArray addObject:option];
    }
    
    [self.rootViewController.onboardingModel userSelectedOption:option atScreenIndex:self.indexOfView];
    switch (self.indexOfView) {
        case 0:
            // Irrelevant
            break;
        case 1: {
            if (indexPath.section == 0 || indexPath.section == 1) {
                // filter by Germany
                [self.rootViewController setFilterByLocationEnabled:YES];
            } else {
                // no location filter
                [self.rootViewController setFilterByLocationEnabled:NO];
            }
            break;
        }
        case 2:
            // Irrelevant
            break;
        case 3:
            // Irrelevant
            break;
        default:
            break;
    }
    
    [self.rootViewController showNextViewController];
}

#pragma mark - view methods
- (void)viewDidLoad
{
    [super viewDidLoad];

    self.titleLabel.text = self.titleString;
    self.backgroundImageView.image = [UIImage imageNamed:self.imageNameString];
}

- (void)reloadSelection
{
    if (self.rootViewController.onboardingModel.selectedOptionAtScreensDictionary) {
        OnboardingOption *option = [self.rootViewController.onboardingModel.selectedOptionAtScreensDictionary nonNullObjectForKey:@(self.indexOfView)];
        if (option) {
            self.selectedOption = option;
            NSInteger index = [self.optionsToDisplay indexOfObject:option];
            [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index] animated:YES scrollPosition:UITableViewScrollPositionNone];
        }
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self reloadSelection];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

@end

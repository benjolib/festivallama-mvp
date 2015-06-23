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
    SelectionTableViewCell *cell = (SelectionTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"cell"];

    OnboardingOption *option = self.optionsToDisplay[indexPath.section];
    cell.titleLabel.text = option.title;

    BOOL cellSelected = [option isEqual:self.selectedOption];
//    [cell setSelected:cellSelected animated:YES];
    if (cellSelected) {
        [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
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
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    OnboardingOption *option = self.optionsToDisplay[indexPath.row];

    if ([self.selectedOptionsArray containsObject:option]) {
        [self.selectedOptionsArray removeObject:option];
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    } else {
        [self.selectedOptionsArray addObject:option];
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];

        [self.rootViewController.onboardingModel userSelectedOption:option atScreenIndex:self.indexOfView];
        switch (self.indexOfView) {
            case 0:
                // Irrelevant
                break;
            case 1: {
                if (indexPath.row == 0 || indexPath.row == 1) {
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
}

#pragma mark - view methods
- (void)viewDidLoad
{
    [super viewDidLoad];

    self.titleLabel.text = self.titleString;
    self.backgroundImageView.image = [UIImage imageNamed:self.imageNameString];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    if (self.rootViewController.onboardingModel.selectedOptionAtScreensDictionary) {
        OnboardingOption *option = [self.rootViewController.onboardingModel.selectedOptionAtScreensDictionary nonNullObjectForKey:@(self.indexOfView)];
        if (option) {
            self.selectedOption = option;
            [self.tableView reloadData];
        }
    }
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

@end

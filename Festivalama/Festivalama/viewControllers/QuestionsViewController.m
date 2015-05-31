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

@interface QuestionsViewController ()
@property (nonatomic, strong, readwrite) NSMutableArray *selectedOptionsArray;
@end

@implementation QuestionsViewController

- (void)setViewTitle:(NSString*)title
{
    self.titleLabel.text = title;
}

#pragma mark - collectionView methods
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.optionsToDisplay.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    OnboardingOption *option = self.optionsToDisplay[indexPath.row];

    SelectionCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[SelectionCollectionViewCell cellIdentifier] forIndexPath:indexPath];
    cell.titleLabel.text = option.title;

    cell.selected = [self.selectedOptionsArray containsObject:option];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    OnboardingOption *option = self.optionsToDisplay[indexPath.row];

    if ([self.selectedOptionsArray containsObject:option]) {
        [self.selectedOptionsArray removeObject:option];
        [collectionView reloadItemsAtIndexPaths:@[indexPath]];
    } else {
        [self.selectedOptionsArray addObject:option];
        [collectionView reloadItemsAtIndexPaths:@[indexPath]];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    OnboardingOption *option = self.optionsToDisplay[indexPath.row];

    if ([self.selectedOptionsArray containsObject:option]) {
        [self.selectedOptionsArray removeObject:option];
        [collectionView reloadItemsAtIndexPaths:@[indexPath]];
    }
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0.0, 20.0, 0.0, 20.0);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((CGRectGetWidth(collectionView.frame) / 2) - 36, 60.0);
}

#pragma mark - view methods
- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end

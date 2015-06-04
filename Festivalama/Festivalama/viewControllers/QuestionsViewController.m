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

static NSInteger cellHeight = 60.0;

@interface QuestionsViewController ()
@property (nonatomic, strong, readwrite) NSMutableArray *selectedOptionsArray;
@property (nonatomic, copy) NSString *titleString;
@property (nonatomic, copy) NSString *imageNameString;
@end

@implementation QuestionsViewController

- (void)setViewTitle:(NSString*)title backgroundImage:(NSString*)imageName
{
    self.titleString = title;
    self.imageNameString = imageName;
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

        switch (self.pageNumber) {
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

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return (CGRectGetHeight(collectionView.frame) / self.optionsToDisplay.count) - cellHeight;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(CGRectGetWidth(collectionView.frame) - 40.0, cellHeight);
}

#pragma mark - view methods
- (void)viewDidLoad
{
    [super viewDidLoad];

    self.titleLabel.text = self.titleString;
    self.backgroundImageView.image = [UIImage imageNamed:self.imageNameString];

    [self.collectionView reloadData];
}

@end

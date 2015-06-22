//
//  MusicGenreSelectionViewController.m
//  Festivalama
//
//  Created by Sztanyi Szabolcs on 30/05/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#import "MusicGenreSelectionViewController.h"
#import "ContinueButton.h"
#import "Genre.h"
#import "SelectionCollectionViewCell.h"
#import "CenterCollectionViewLayout.h"

@interface MusicGenreSelectionViewController () <CenterCollectionViewLayoutProtocol>
@property (nonatomic, strong, readwrite) NSMutableArray *selectedGenresArray;
@property (nonatomic, strong) CenterCollectionViewLayout *centerCollectionViewLayout;
@property (nonatomic, copy) NSString *titleString;
@property (nonatomic, copy) NSString *imageNameString;
@property (nonatomic) NSInteger numberOfSections;
@end

@implementation MusicGenreSelectionViewController

- (Genre*)genreAtIndexPath:(NSIndexPath*)indexPath
{
    NSInteger sumSections = 0;
    for (int i = 0; i < indexPath.section; i++) {
        NSInteger rowsInSection = [self.collectionView numberOfItemsInSection:i];
        sumSections += rowsInSection;
    }
    return self.allGenresArray[sumSections + indexPath.row];
}

- (IBAction)continueButtonPressed:(id)sender
{
    [self.rootViewController showNextViewController];
}

#pragma mark - center layout delegate method
- (Genre *)titleForObjectAtIndexpath:(NSIndexPath *)indexPath
{
    return [self genreAtIndexPath:indexPath];
}

#pragma mark - collectionView methods
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.numberOfSections;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 3;
//    return self.allGenresArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    Genre *genre = [self genreAtIndexPath:indexPath];

    SelectionCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[SelectionCollectionViewCell cellIdentifier] forIndexPath:indexPath];
    cell.titleLabel.text = genre.name;

    BOOL contained = [self.selectedGenresArray containsObject:genre];
    cell.selected = contained;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    Genre *genre = [self genreAtIndexPath:indexPath];
    if (!self.selectedGenresArray) {
        self.selectedGenresArray = [NSMutableArray array];
    }

    if ([self.selectedGenresArray containsObject:genre]) {
        [self.selectedGenresArray removeObject:genre];
        [collectionView reloadItemsAtIndexPaths:@[indexPath]];
        [self updateOnboardingModel];
    } else {
        [self.selectedGenresArray addObject:genre];
        [collectionView reloadItemsAtIndexPaths:@[indexPath]];
        [self updateOnboardingModel];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    Genre *genre = [self genreAtIndexPath:indexPath];
    if ([self.selectedGenresArray containsObject:genre]) {
        [self.selectedGenresArray removeObject:genre];
        [collectionView reloadItemsAtIndexPaths:@[indexPath]];
        [self updateOnboardingModel];
    }
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10.0, 0.0, 0.0, 0.0);
}

//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    return CGSizeMake((CGRectGetWidth(collectionView.frame) / 2) - 30, 60.0);
//}

- (void)updateOnboardingModel
{
    self.rootViewController.onboardingModel.selectedGenres = [_selectedGenresArray copy];
    self.continueButton.enabled = self.selectedGenresArray.count > 0;
}

#pragma mark - view methods
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.selectedGenresArray = [NSMutableArray array];

    self.continueButton.enabled = self.selectedGenresArray.count > 0;
    self.titleLabel.text = self.titleString;
    self.backgroundImageView.image = [UIImage imageNamed:self.imageNameString];
    
    if (self.allGenresArray.count % 3 != 0) {
        self.numberOfSections = self.allGenresArray.count / 3 + 1;
    } else {
        self.numberOfSections = self.allGenresArray.count / 3;
    }
    
    self.centerCollectionViewLayout = [[CenterCollectionViewLayout alloc] init];
    self.centerCollectionViewLayout.customDataSource = self;
    
    self.collectionView.collectionViewLayout = self.centerCollectionViewLayout;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.rootViewController.onboardingModel.selectedGenres.count > 0) {
        self.selectedGenresArray = [self.rootViewController.onboardingModel.selectedGenres mutableCopy];
        self.continueButton.enabled = self.selectedGenresArray.count > 0;
    }
    [self.collectionView reloadData];
}

- (void)setViewTitle:(NSString*)title backgroundImage:(NSString*)imageName
{
    self.titleString = title;
    self.imageNameString = imageName;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

@end

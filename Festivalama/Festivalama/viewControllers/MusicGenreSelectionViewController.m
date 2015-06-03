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

@interface MusicGenreSelectionViewController ()
@property (nonatomic, strong, readwrite) NSMutableArray *selectedGenresArray;
@property (nonatomic, copy) NSString *titleString;
@property (nonatomic, copy) NSString *imageNameString;
@end

@implementation MusicGenreSelectionViewController

- (Genre*)genreAtIndexPath:(NSIndexPath*)indexPath
{
    return self.allGenresArray[indexPath.row];
}

- (IBAction)continueButtonPressed:(id)sender
{
    [self.rootViewController showNextViewController];
}

#pragma mark - collectionView methods
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.allGenresArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    Genre *genre = [self genreAtIndexPath:indexPath];

    SelectionCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[SelectionCollectionViewCell cellIdentifier] forIndexPath:indexPath];
    cell.titleLabel.text = genre.name;

    cell.selected = [self.selectedGenresArray containsObject:genre];
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
    } else {
        [self.selectedGenresArray addObject:genre];
        [collectionView reloadItemsAtIndexPaths:@[indexPath]];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    Genre *genre = [self genreAtIndexPath:indexPath];
    if ([self.selectedGenresArray containsObject:genre]) {
        [self.selectedGenresArray removeObject:genre];
        [collectionView reloadItemsAtIndexPaths:@[indexPath]];
    }
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0.0, 20.0, 0.0, 20.0);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((CGRectGetWidth(collectionView.frame) / 2) - 30, 60.0);
}

- (NSMutableArray *)selectedGenresArray
{
    self.continueButton.enabled = _selectedGenresArray.count > 0;
    return _selectedGenresArray;
}

#pragma mark - view methods
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.selectedGenresArray = [NSMutableArray array];

    self.continueButton.enabled = self.selectedGenresArray.count > 0;
    self.titleLabel.text = self.titleString;
    self.backgroundImageView.image = [UIImage imageNamed:self.imageNameString];
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

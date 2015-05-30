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
@end

@implementation MusicGenreSelectionViewController

- (Genre*)genreAtIndexPath:(NSIndexPath*)indexPath
{
    return self.allGenresArray[indexPath.row];
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
    if ([self.selectedGenresArray containsObject:genre]) {
        return;
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
    return UIEdgeInsetsMake(0.0, 10.0, 20.0, 10.0);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(CGRectGetWidth(collectionView.frame) / 2, 60.0);
}

#pragma mark - view methods
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.selectedGenresArray = [NSMutableArray array];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

@end

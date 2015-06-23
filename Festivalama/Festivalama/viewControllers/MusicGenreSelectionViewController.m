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
    return self.allGenresArray[indexPath.row];
}

- (IBAction)continueButtonPressed:(id)sender
{
    [self.rootViewController showNextViewController];
}

#pragma mark - center layout delegate method
- (Genre *)titleForObjectAtIndexpath:(NSIndexPath *)indexPath
{
    if (indexPath.item >= self.allGenresArray.count) {
        return nil;
    }
    return [self genreAtIndexPath:indexPath];
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
        [collectionView deselectItemAtIndexPath:indexPath animated:YES];
        [self updateOnboardingModel];
    } else {
        [self.selectedGenresArray addObject:genre];
        [self updateOnboardingModel];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    Genre *genre = [self genreAtIndexPath:indexPath];
    if ([self.selectedGenresArray containsObject:genre]) {
        [self.selectedGenresArray removeObject:genre];
        [collectionView deselectItemAtIndexPath:indexPath animated:YES];
        [self updateOnboardingModel];
    }
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10.0, 0.0, 0.0, 0.0);
}

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
    self.centerCollectionViewLayout.scrollDirection = UICollectionViewScrollDirectionVertical;

    self.collectionView.allowsMultipleSelection = YES;
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

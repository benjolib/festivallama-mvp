//
//  MusicGenreSelectionViewController.h
//  Festivalama
//
//  Created by Sztanyi Szabolcs on 30/05/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#import "WelcomeBaseViewController.h"

@class ContinueButton;

@protocol MusicGenreSelectionViewControllerDelegate <NSObject>

- (void)musicGenreSelectionNumberOfSelectedItemsChanged:(NSInteger)numberOfSelectedItems;

@end

@interface MusicGenreSelectionViewController : WelcomeBaseViewController <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, weak) id <MusicGenreSelectionViewControllerDelegate> delegate;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;

@property (nonatomic, strong) NSArray *allGenresArray;
@property (nonatomic, strong, readonly) NSMutableArray *selectedGenresArray;

- (void)setViewTitle:(NSString*)title backgroundImage:(NSString*)imageName;

@end

//
//  MusicGenreSelectionViewController.h
//  Festivalama
//
//  Created by Sztanyi Szabolcs on 30/05/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ContinueButton;

@interface MusicGenreSelectionViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet ContinueButton *continueButton;

@property (nonatomic, strong) NSArray *allGenresArray;
@property (nonatomic, strong, readonly) NSMutableArray *selectedGenresArray;

@end

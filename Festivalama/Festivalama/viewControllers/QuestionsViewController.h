//
//  QuestionsViewController.h
//  Festivalama
//
//  Created by Sztanyi Szabolcs on 30/05/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuestionsViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (nonatomic, strong) NSArray *optionsToDisplay;
@property (nonatomic, strong, readonly) NSMutableArray *selectedOptionsArray;

- (void)setViewTitle:(NSString*)title;

@end

//
//  CenterCollectionViewLayout.h
//  Festivalama
//
//  Created by Szabolcs Sztanyi on 22/06/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Genre;

@protocol CenterCollectionViewLayoutProtocol <NSObject>

- (Genre*)titleForObjectAtIndexpath:(NSIndexPath*)indexPath;

@end

@interface CenterCollectionViewLayout : UICollectionViewFlowLayout

@property (nonatomic, weak) id<CenterCollectionViewLayoutProtocol> customDataSource;

@end

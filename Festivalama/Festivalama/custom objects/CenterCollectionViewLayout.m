//
//  CenterCollectionViewLayout.m
//  Festivalama
//
//  Created by Szabolcs Sztanyi on 22/06/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#import "CenterCollectionViewLayout.h"
#import "Genre.h"
#import "UIFont+LatoFonts.h"

@interface CenterCollectionViewLayout ()
@property (nonatomic, strong) NSMutableDictionary *cellWidthDictionary;
@property (nonatomic, strong) NSMutableDictionary *cellPositionsDictionary;
@end

@implementation CenterCollectionViewLayout

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSArray *attributes = [super layoutAttributesForElementsInRect:rect];
    
    for (UICollectionViewLayoutAttributes *attribute in attributes)
    {
        if (!self.cellWidthDictionary) {
            self.cellWidthDictionary = [NSMutableDictionary dictionary];
        }
        
        if (!self.cellPositionsDictionary) {
            self.cellPositionsDictionary = [NSMutableDictionary dictionary];
        }
        
        CGFloat itemMargin = 10;
        
        if (attribute.indexPath.item == 0)
        {
            NSIndexPath *currentIndexPath = attribute.indexPath;
            NSIndexPath *secondIndexPath = [NSIndexPath indexPathForItem:attribute.indexPath.item+1 inSection:attribute.indexPath.section];
            NSIndexPath *thirdIndexPath = [NSIndexPath indexPathForItem:attribute.indexPath.item+2 inSection:attribute.indexPath.section];
            
            CGFloat currentWidth = [self widthForIndexPath:currentIndexPath];
            CGFloat firstWidth = [self widthForIndexPath:secondIndexPath];
            CGFloat secondWidth = [self widthForIndexPath:thirdIndexPath];
            
            CGFloat itemsWidth = itemMargin + currentWidth + itemMargin + firstWidth + itemMargin + secondWidth + itemMargin;
            
            CGFloat leftMargin = (CGRectGetWidth(rect) - itemsWidth) / 2;
            
            CGRect originalFrame = attribute.frame;
            attribute.frame = CGRectMake(leftMargin,
                                         originalFrame.origin.y,
                                         currentWidth,
                                         originalFrame.size.height);
            
            if (!self.cellPositionsDictionary[currentIndexPath]) {
                [self.cellPositionsDictionary setObject:NSStringFromCGRect(attribute.frame) forKey:currentIndexPath];
            }
        }
        else if (attribute.indexPath.item == 1)
        {
            NSIndexPath *previousIndexPath = [NSIndexPath indexPathForItem:attribute.indexPath.item-1 inSection:attribute.indexPath.section];
            CGFloat currentWidth = [self widthForIndexPath:attribute.indexPath];
            
            CGRect previousCellFrame = CGRectFromString(self.cellPositionsDictionary[previousIndexPath]);
            
            CGRect originalFrame = attribute.frame;
            attribute.frame = CGRectMake(CGRectGetMaxX(previousCellFrame) + itemMargin,
                                         originalFrame.origin.y,
                                         currentWidth,
                                         originalFrame.size.height);
            
            if (!self.cellPositionsDictionary[attribute.indexPath]) {
                [self.cellPositionsDictionary setObject:NSStringFromCGRect(attribute.frame) forKey:attribute.indexPath];
            }
        }
        else
        {
            NSIndexPath *previousIndexPath = [NSIndexPath indexPathForItem:attribute.indexPath.item-1 inSection:attribute.indexPath.section];
            CGFloat currentWidth = [self widthForIndexPath:attribute.indexPath];
            
            CGRect previousCellFrame = CGRectFromString(self.cellPositionsDictionary[previousIndexPath]);
            
            CGRect originalFrame = attribute.frame;
            attribute.frame = CGRectMake(CGRectGetMaxX(previousCellFrame) + itemMargin,
                                         originalFrame.origin.y,
                                         currentWidth,
                                         originalFrame.size.height);
            
            if (!self.cellPositionsDictionary[attribute.indexPath]) {
                [self.cellPositionsDictionary setObject:NSStringFromCGRect(attribute.frame) forKey:attribute.indexPath];
            }
        }
    }
    
    return attributes;
}

- (CGFloat)widthForIndexPath:(NSIndexPath*)indexpath
{
    if (self.cellWidthDictionary[indexpath]) {
        return [self.cellWidthDictionary[indexpath] floatValue];
    }
    
    Genre *title = [self.customDataSource titleForObjectAtIndexpath:indexpath];
    CGFloat width = [self widthForGenreName:title] + (4 * 10);
    
    [self.cellWidthDictionary setObject:@(width) forKey:indexpath];
    return width;
}

- (CGFloat)widthForGenreName:(Genre*)genre
{
    CGRect labelRect = [genre.name boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 50.0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont latoBoldFontWithSize:16.0]} context:nil];
    
    return labelRect.size.width;
}

@end

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
@property (nonatomic, strong) NSMutableDictionary *cellAttributesDictionary;
@end

@implementation CenterCollectionViewLayout


- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    if (!self.cellWidthDictionary) {
        self.cellWidthDictionary = [NSMutableDictionary dictionary];
    }
    if (!self.cellPositionsDictionary) {
        self.cellPositionsDictionary = [NSMutableDictionary dictionary];
    }
    
    if (!self.cellAttributesDictionary) {
        self.cellAttributesDictionary = [NSMutableDictionary dictionary];
    }
    
    NSInteger sectionIndex = 0;
    NSArray *attributes = [super layoutAttributesForElementsInRect:rect];
    for (UICollectionViewLayoutAttributes *attribute in attributes)
    {
        if (self.cellAttributesDictionary[attribute.indexPath]) {
            attribute.frame = ((UICollectionViewLayoutAttributes*)self.cellAttributesDictionary[attribute.indexPath]).frame;
            continue;
        }
        
        BOOL usedFourthCell = NO;
        CGFloat width1 = [self widthForIndexPath:attribute.indexPath];
        
        NSIndexPath *secondIndexPath = [NSIndexPath indexPathForItem:attribute.indexPath.item+1 inSection:attribute.indexPath.section];
        NSIndexPath *thirdIndexPath = [NSIndexPath indexPathForItem:attribute.indexPath.item+2 inSection:attribute.indexPath.section];
        NSIndexPath *fourthIndexPath = [NSIndexPath indexPathForItem:attribute.indexPath.item+3 inSection:attribute.indexPath.section];
        
        UICollectionViewLayoutAttributes *attribute2 = [self layoutAttributesForItemAtIndexPath:secondIndexPath];
        UICollectionViewLayoutAttributes *attribute3 = [self layoutAttributesForItemAtIndexPath:thirdIndexPath];
        UICollectionViewLayoutAttributes *attribute4 = [self layoutAttributesForItemAtIndexPath:fourthIndexPath];
        
        CGFloat width2 = [self widthForIndexPath:secondIndexPath];
        CGFloat width3 = [self widthForIndexPath:thirdIndexPath];
        CGFloat width4 = [self widthForIndexPath:fourthIndexPath];
        
        CGFloat itemMargin = 10.0;
        CGFloat viewWidths = 0;
        
        if (width4 != 0 && width3 != 0) // we have a fourth indexPath too
        {
            viewWidths = width1 + itemMargin + width2 + itemMargin + width3 + itemMargin + width4;
            if (CGRectGetWidth(rect) >= (viewWidths + (2 * 20))) { // 20.0 px margin on both sides
                // if the container width is smaller than the max size, than we can fit 4 items in a row.
                usedFourthCell = YES;
            } else {
                // if not, just use 3 cells
                viewWidths = width1 + itemMargin + width2 + itemMargin + width3;
                usedFourthCell = NO;
            }
        }
        else
        {
            usedFourthCell = NO;
            if (width3 != 0) {
                viewWidths = width1 + itemMargin + width2 + itemMargin + width3;
            } else {
                viewWidths = width1 + itemMargin + width2;
            }
        }
        
        CGFloat leftMargin = (CGRectGetWidth(rect) - viewWidths) / 2;
        
        CGFloat yOrigin = sectionIndex * 55;
        
        CGFloat maxXOrigin = [self saveCellAtIndexPath:attribute.indexPath attribute:attribute withWidth:width1 xOrigin:leftMargin andYOrigin:yOrigin];
        maxXOrigin = [self saveCellAtIndexPath:secondIndexPath attribute:attribute2 withWidth:width2 xOrigin:maxXOrigin andYOrigin:yOrigin];
        maxXOrigin = [self saveCellAtIndexPath:thirdIndexPath attribute:attribute3 withWidth:width3 xOrigin:maxXOrigin andYOrigin:yOrigin];
        if (usedFourthCell) {
            [self saveCellAtIndexPath:fourthIndexPath attribute:attribute4 withWidth:width4 xOrigin:maxXOrigin andYOrigin:yOrigin];
        }
        
        sectionIndex++;
    }
    return attributes;
}

- (CGFloat)saveCellAtIndexPath:(NSIndexPath*)indexPath attribute:(UICollectionViewLayoutAttributes*)attribute withWidth:(CGFloat)width xOrigin:(CGFloat)xOrigin andYOrigin:(CGFloat)yOrigin
{
    CGRect attributeFrame = attribute.frame;
    attributeFrame.origin.x = xOrigin;
    attributeFrame.origin.y = yOrigin;
    attributeFrame.size.width = width;
    attributeFrame.size.height = 45.0;
    attribute.frame = attributeFrame;
    
    if (!self.cellAttributesDictionary[indexPath]) {
        [self.cellAttributesDictionary setObject:attribute forKey:indexPath];
    }
    
    return CGRectGetMaxX(attributeFrame) + 10.0;
}

- (CGFloat)widthForIndexPath:(NSIndexPath*)indexpath
{
    if (self.cellWidthDictionary[indexpath]) {
        return [self.cellWidthDictionary[indexpath] floatValue];
    }
    
    Genre *title = [self.customDataSource titleForObjectAtIndexpath:indexpath];
    if (!title) {
        return 0;
    }
    CGFloat width = [self widthForGenreName:title] + (3 * 10);
    
    [self.cellWidthDictionary setObject:@(width) forKey:indexpath];
    return width;
}

- (CGFloat)widthForGenreName:(Genre*)genre
{
    CGRect labelRect = [genre.name boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 50.0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont latoBoldFontWithSize:16.0]} context:nil];
    
    return labelRect.size.width;
}

@end

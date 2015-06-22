//
//  SelectionCollectionViewCell.m
//  Festivalama
//
//  Created by Sztanyi Szabolcs on 30/05/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#import "SelectionCollectionViewCell.h"
#import "UIColor+AppColors.h"

@implementation SelectionCollectionViewCell

+ (NSString*)cellIdentifier
{
    return @"cell";
}

- (void)awakeFromNib
{
    [super awakeFromNib];

    self.cellBackgroundView.backgroundColor = [UIColor clearColor];
    self.cellBackgroundView.layer.cornerRadius = 26;
    self.cellBackgroundView.layer.borderWidth = 1.0;
    self.cellBackgroundView.layer.borderColor = [UIColor whiteColor].CGColor;
}

- (void)setHighlighted:(BOOL)highlighted
{
    if (highlighted) {
        self.cellBackgroundView.backgroundColor = [UIColor whiteColor];
        self.titleLabel.textColor = [UIColor globalGreenColor];
    } else {
        self.cellBackgroundView.backgroundColor = [UIColor clearColor];
        self.titleLabel.textColor = [UIColor whiteColor];
    }
}

- (void)setSelected:(BOOL)selected
{
    if (selected) {
        self.cellBackgroundView.backgroundColor = [UIColor whiteColor];
        self.titleLabel.textColor = [UIColor globalGreenColor];
    } else {
        self.cellBackgroundView.backgroundColor = [UIColor clearColor];
        self.titleLabel.textColor = [UIColor whiteColor];
    }
}

@end

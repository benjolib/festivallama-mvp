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

    self.contentView.backgroundColor = [UIColor clearColor];
    self.contentView.layer.cornerRadius = 24;
    self.contentView.layer.borderWidth = 1.0;
    self.contentView.layer.borderColor = [UIColor whiteColor].CGColor;
}

- (void)setHighlighted:(BOOL)highlighted
{
    if (highlighted) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.titleLabel.textColor = [UIColor globalGreenColor];
    } else {
        self.contentView.backgroundColor = [UIColor clearColor];
        self.titleLabel.textColor = [UIColor whiteColor];
    }
}

- (void)setSelected:(BOOL)selected
{
    if (selected) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.titleLabel.textColor = [UIColor globalGreenColor];
    } else {
        self.contentView.backgroundColor = [UIColor clearColor];
        self.titleLabel.textColor = [UIColor whiteColor];
    }
}

@end

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

    self.backgroundView.backgroundColor = [UIColor clearColor];
    self.backgroundView.layer.cornerRadius = 20;
    self.backgroundView.layer.borderWidth = 1.0;
    self.backgroundView.layer.borderColor = [UIColor whiteColor];
}

- (void)setHighlighted:(BOOL)highlighted
{
    if (highlighted) {
        self.backgroundView.backgroundColor = [UIColor whiteColor];
        self.titleLabel.textColor = [UIColor globalGreenColor];
    } else {
        self.backgroundView.backgroundColor = [UIColor clearColor];
        self.titleLabel.textColor = [UIColor whiteColor];
    }
}

- (void)setSelected:(BOOL)selected
{
    if (selected) {
        self.backgroundView.backgroundColor = [UIColor whiteColor];
        self.titleLabel.textColor = [UIColor globalGreenColor];
    } else {
        self.backgroundView.backgroundColor = [UIColor clearColor];
        self.titleLabel.textColor = [UIColor whiteColor];
    }
}

@end

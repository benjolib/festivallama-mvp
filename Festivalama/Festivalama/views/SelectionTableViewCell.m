//
//  SelectionTableViewCell.m
//  Festivalama
//
//  Created by Sztanyi Szabolcs on 11/06/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#import "SelectionTableViewCell.h"
#import "UIColor+AppColors.h"

@implementation SelectionTableViewCell

+ (NSString*)cellIdentifier
{
    return @"cell";
}

- (void)awakeFromNib
{
    [super awakeFromNib];

    self.cellBackgroundView.backgroundColor = [UIColor clearColor];
    self.cellBackgroundView.layer.cornerRadius = 32;
    self.cellBackgroundView.layer.borderWidth = 1.0;
    self.cellBackgroundView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.cellBackgroundView.clipsToBounds = YES;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    if (highlighted) {
        self.cellBackgroundView.backgroundColor = [UIColor whiteColor];
        self.titleLabel.textColor = [UIColor globalGreenColor];
    } else {
        self.cellBackgroundView.backgroundColor = [UIColor clearColor];
        self.titleLabel.textColor = [UIColor whiteColor];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
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

//
//  FestivalTableViewCell.m
//  Festivalama
//
//  Created by Sztanyi Szabolcs on 01/06/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#import "FestivalTableViewCell.h"
#import "UIColor+AppColors.h"

@implementation FestivalTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];

    self.popularityView.layer.cornerRadius = 2.0;
    self.popularityLabel.textColor = [UIColor globalGreenColor];
}

- (void)showSavedState:(BOOL)saved
{
    if (saved) {
        [self.calendarButton setImage:[UIImage imageNamed:@"festivalCalendarButtonSelected"] forState:UIControlStateNormal];
    } else {
        [self.calendarButton setImage:[UIImage imageNamed:@"festivalCalendarButton"] forState:UIControlStateNormal];
    }
}

- (void)setPopularityValue:(NSNumber*)percentage
{
    if ([percentage integerValue] == 0) {
        self.popularityLabelWidthConstraint.constant = 0.0;
        self.nameLabelLeadingConstraint.constant = 0.0;
        [self.popularityView layoutIfNeeded];
        return;
    }
    self.popularityView.hidden = NO;

    self.popularityLabelWidthConstraint.constant = 21.0;
    self.nameLabelLeadingConstraint.constant = 5.0;

    self.popularityLabel.text = [NSString stringWithFormat:@"%ld%%", (long)[percentage integerValue]];
    [self.popularityView layoutIfNeeded];
}

- (void)hidePopularityView
{
    self.popularityView.hidden = YES;

    self.popularityLabelWidthConstraint.constant = 0.0;
    self.nameLabelLeadingConstraint.constant = 0.0;

    [self.popularityView layoutIfNeeded];
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    self.popularityView.hidden = NO;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    if (highlighted) {
        self.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.2];
    } else {
        self.backgroundColor = [UIColor clearColor];
    }
}

@end

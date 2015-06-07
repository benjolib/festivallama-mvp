//
//  FestivalDetailInfoViewController.m
//  Festivalama
//
//  Created by Sztanyi Szabolcs on 07/06/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#import "FestivalDetailInfoViewController.h"
#import "FestivalModel.h"

@interface FestivalDetailInfoViewController ()

@end

@implementation FestivalDetailInfoViewController

#pragma mark - view methods
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self displayFestivalInfo];

    [self adjustViewSizes];
}

- (void)displayFestivalInfo
{
    self.infoTextLabel.text = self.festivalToDisplay.festivalDescription;
    self.festivalTypeLabel.text = [self.festivalToDisplay category];
    self.festivalTimeLabel.text = [self.festivalToDisplay festivalInfoDateString];
    self.festivalLocationLabel.text = [self.festivalToDisplay infoLocationString];
    self.festivalCostsLabel.text = [self.festivalToDisplay admission];
}

- (void)adjustViewSizes
{
    NSDictionary *attributes = @{NSFontAttributeName:self.infoTextLabel.font};
    NSInteger options = NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesLineFragmentOrigin;
    CGRect labelRect = [self.infoTextLabel.text boundingRectWithSize:CGSizeMake(CGRectGetWidth(self.infoTextLabel.frame), CGFLOAT_MAX) options:options attributes:attributes context:NULL];

    self.infoTextLabelHeightConstraint.constant = labelRect.size.height + 20.0;

    CGFloat viewHeight = CGRectGetMaxY(self.festivalCostsLabel.frame) + 20.0;
    self.containerViewHeightConstraint.constant = viewHeight;

    [self.view layoutIfNeeded];
}

@end

//
//  FestivalDetailInfoViewController.m
//  Festivalama
//
//  Created by Sztanyi Szabolcs on 07/06/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#import "FestivalDetailInfoViewController.h"
#import "FestivalModel.h"
#import "UIFont+LatoFonts.h"

@implementation FestivalDetailInfoViewController

#pragma mark - view methods
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    self.containerView.backgroundColor = [UIColor clearColor];

    self.infoTextLabel.font = [UIFont latoRegularFontWithSize:16.0];
    [self refreshView];
    [self.scrollView flashScrollIndicators];
}

- (void)refreshView
{
    [super refreshView];
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
    if (!self.infoTextLabel) {
        return;
    }
    
    CGSize intr = self.infoTextLabel.intrinsicContentSize;

//    NSDictionary *attributes = @{NSFontAttributeName:[UIFont latoRegularFontWithSize:16.0]};
//    NSInteger options = NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesLineFragmentOrigin;
//    CGRect labelRect = [self.infoTextLabel.text boundingRectWithSize:CGSizeMake(CGRectGetWidth(self.infoTextLabel.frame), CGFLOAT_MAX) options:options attributes:attributes context:NULL];

    self.infoTextLabelHeightConstraint.constant = intr.height;

    CGRect infoTextLabelFrame = self.infoTextLabel.frame;
    infoTextLabelFrame.size.height = self.infoTextLabelHeightConstraint.constant;
    self.infoTextLabel.frame = infoTextLabelFrame;

    [self.view setNeedsDisplay];

    CGFloat viewHeight = CGRectGetMaxY(self.festivalCostsLabel.frame) + 20.0 + intr.height;
    self.containerViewHeightConstraint.constant = viewHeight;

    self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.view.frame), self.containerViewHeightConstraint.constant);
}

@end

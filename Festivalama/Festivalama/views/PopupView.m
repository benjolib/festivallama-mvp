//
//  PopupView.m
//  Festivalama
//
//  Created by Sztanyi Szabolcs on 28/05/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#import "PopupView.h"
#import "PopupViewButton.h"
#import "UIImage+ImageEffects.h"
#import "UIColor+AppColors.h"

@interface PopupView ()
@property (nonatomic, strong) UIView *parentView;
@property (nonatomic, strong) UIImageView *blurredBackgroundView;
@end

@implementation PopupView

- (instancetype)initWithDelegate:(id <PopupViewDelegate>)delegate
{
    self = [super init];
    if (self) {
        NSArray *bundle = [[NSBundle mainBundle] loadNibNamed:@"PopupView" owner:nil options:nil];
        for (id object in bundle) {
            if ([object isKindOfClass:[PopupView class]]) {
                self = object;
                break;
            }
        }
        self.delegate = delegate;
        self.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.2];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.popupBackgroundView.layer.cornerRadius = 15.0;
    self.popupBackgroundView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.8];

    self.titleLabel.textColor = [UIColor globalGreenColor];
    self.textLabel.textColor = [UIColor globalGreenColor];
}

#pragma mark - button methods
- (void)confirmButtonPressed:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(popupViewConfirmButtonPressed)]) {
        [self.delegate popupViewConfirmButtonPressed];
    }
    [self dismissViewWithAnimation:YES];
}

- (void)cancelButtonPressed:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(popupViewCancelButtonPressed)]) {
        [self.delegate popupViewCancelButtonPressed];
    }
    [self dismissViewWithAnimation:YES];
}

#pragma mark - setup methods
- (void)setupWithConfirmButtonTitle:(NSString*)confirmTitle cancelButtonTitle:(NSString*)cancelTitle viewTitle:(NSString*)viewTitle text:(NSString*)text icon:(UIImage*)icon
{
    self.iconImageView.image = icon;
    self.titleLabel.text = viewTitle;
    self.textLabel.text = text;

    if (!self.confirmButton) {
        self.confirmButton = [[PopupViewButton alloc] init];
        self.confirmButton.frame = CGRectMake(20.0, 5.0, CGRectGetWidth(self.popupBackgroundView.frame) - 40.0, 60.0);
        [self.confirmButton addTarget:self action:@selector(confirmButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        self.confirmButton.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self.buttonsContainerView addSubview:self.confirmButton];
    }
    [self.confirmButton setTitle:confirmTitle forState:UIControlStateNormal];
    [self.confirmButton setupAsConfirmButton];

    const CGFloat buttonPadding = 10.0;

    if (cancelTitle.length > 0) {
        if (!self.cancelButton) {
            self.cancelButton = [[PopupViewButton alloc] init];
            self.cancelButton.frame = CGRectMake(20.0, CGRectGetMaxY(self.confirmButton.frame) + buttonPadding, CGRectGetWidth(self.popupBackgroundView.frame) - 40.0, 60.0);
            [self.cancelButton addTarget:self action:@selector(cancelButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            self.cancelButton.autoresizingMask = UIViewAutoresizingFlexibleWidth;
            [self.buttonsContainerView addSubview:self.cancelButton];
        }
        [self.cancelButton setTitle:cancelTitle forState:UIControlStateNormal];
        [self.cancelButton setupAsCancelButton];
    } else {
        [self.cancelButton removeFromSuperview];
    }

    CGFloat buttonsContainerViewHeight = CGRectGetMaxY(self.confirmButton.frame) + CGRectGetHeight(self.cancelButton.frame) + buttonPadding;
    self.buttonsContainerViewHeightConstraint.constant = buttonsContainerViewHeight;

    [self adjustViewSize];
}

- (void)adjustViewSize
{
    NSDictionary *attributes = @{NSFontAttributeName:self.textLabel.font};
    NSInteger options = NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesLineFragmentOrigin;
    CGRect labelRect = [self.textLabel.text boundingRectWithSize:CGSizeMake(CGRectGetWidth(self.textLabel.frame), CGFLOAT_MAX) options:options attributes:attributes context:NULL];

    self.textLabelHeightConstraint.constant = labelRect.size.height + 20.0;
    
    CGFloat popupHeight = CGRectGetMinY(self.textLabel.frame) + self.textLabelHeightConstraint.constant + 15.0 + self.buttonsContainerViewHeightConstraint.constant;

    self.popupBackgroundViewHeightConstraint.constant = MAX(popupHeight, 300.0);

    [self setNeedsLayout];
}

#pragma mark - showing/hiding methods
- (void)showPopupViewAnimationOnView:(UIView*)parentView withBlurredBackground:(BOOL)blurBackground
{
    self.parentView = parentView;
    self.frame = parentView.frame;
    [parentView addSubview:self];

    if (blurBackground) {
        [parentView insertSubview:[self createBlurredSnapshotOfView:parentView] belowSubview:self];
    }

    self.alpha = 0.0;
    self.transform = CGAffineTransformMakeScale(1.1, 1.1);

    [UIView animateWithDuration:0.2 animations:^{
        [self setNeedsLayout];
        self.alpha = 1.0;
        self.transform = CGAffineTransformIdentity;
    }];
}

- (UIImageView*)createBlurredSnapshotOfView:(UIView*)view
{
    CGRect frame = view.frame;
    UIGraphicsBeginImageContext(frame.size);
    [view drawViewHierarchyInRect:frame afterScreenUpdates:NO];
    UIImage *snapshotImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    UIImageView *blurredImageView = [[UIImageView alloc] initWithFrame:view.frame];
    blurredImageView.image = [snapshotImage applyLightEffect];
    self.blurredBackgroundView = blurredImageView;
    self.blurredBackgroundView.alpha = 0.95;
    return self.blurredBackgroundView;
}

- (void)dismissViewWithAnimation:(BOOL)animated
{
    [UIView animateWithDuration:0.2 animations:^{
        self.transform = CGAffineTransformMakeScale(0.1, 0.1);
        self.alpha = 0.0;
        self.blurredBackgroundView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [self.blurredBackgroundView removeFromSuperview];
        self.parentView = nil;
    }];
}

@end

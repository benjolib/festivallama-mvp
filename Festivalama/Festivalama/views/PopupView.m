//
//  PopupView.m
//  Festivalama
//
//  Created by Sztanyi Szabolcs on 28/05/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#import "PopupView.h"
#import "PopupViewButton.h"

@interface PopupView ()
@property (nonatomic, strong) UIView *parentView;
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
        self.translatesAutoresizingMaskIntoConstraints = NO;
        self.delegate = delegate;
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.popupBackgroundView.layer.cornerRadius = 15.0;
    self.popupBackgroundView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.8];
}

#pragma mark - button methods
- (IBAction)confirmButtonPressed:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(popupViewConfirmButtonPressed)]) {
        [self.delegate popupViewConfirmButtonPressed];
    }
    [self dismissViewWithAnimation:YES];
}

- (IBAction)cancelButtonPressed:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(popupViewCancelButtonPressed)]) {
        [self.delegate popupViewCancelButtonPressed];
    }
    [self dismissViewWithAnimation:YES];
}

#pragma mark - setup methods
- (void)setupWithConfirmButtonTitle:(NSString*)confirmTitle cancelButtonTitle:(NSString*)cancelTitle viewTitle:(NSString*)viewTitle text:(NSString*)text icon:(UIImage*)icon
{
    [self.confirmButton setTitle:confirmTitle forState:UIControlStateNormal];
    [self.confirmButton setupAsConfirmButton];
    self.iconImageView.image = icon;

    if (cancelTitle.length > 0) {
        [self.cancelButton setTitle:cancelTitle forState:UIControlStateNormal];
        [self.cancelButton setupAsCancelButton];
    } else {
        [self.cancelButton setupAsCancelButton];
        [self hideCancelButton];
    }

    self.titleLabel.text = viewTitle;
    self.textLabel.text = text;

    [self adjustViewSize];
}

- (void)hideCancelButton
{
    [self.cancelButton removeFromSuperview];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.confirmButton attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-20.0]];

    [self setNeedsLayout];
}

- (void)adjustViewSize
{
    NSDictionary *attributes = @{NSFontAttributeName:self.textLabel.font};
    NSInteger options = NSStringDrawingUsesFontLeading | NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin;
    CGRect labelRect = [self.textLabel.text boundingRectWithSize:CGSizeMake(CGRectGetWidth(self.textLabel.frame), 100.0) options:options attributes:attributes context:NULL];

    self.textLabelHeightConstraint.constant = labelRect.size.height;
    [self setNeedsLayout];
}

#pragma mark - showing/hiding methods
- (void)showPopupViewAnimationOnView:(UIView*)parentView
{
    self.parentView = parentView;
    [parentView addSubview:self];
    self.alpha = 0.0;
    
    [UIView animateWithDuration:0.2 animations:^{
        [self setNeedsLayout];
        self.alpha = 1.0;
    }];
}

- (void)dismissViewWithAnimation:(BOOL)animated
{
    [UIView animateWithDuration:0.2 animations:^{
        self.transform = CGAffineTransformMakeScale(0.1, 0.1);
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        self.parentView = nil;
    }];
}

- (void)updateConstraints
{
    if (self.parentView)
    {
        [self.parentView addConstraint:[NSLayoutConstraint constraintWithItem:self.parentView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:1.0 constant:50.0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:450.0]];

        [self.parentView addConstraint:[NSLayoutConstraint constraintWithItem:self.parentView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];

        [self.parentView addConstraint:[NSLayoutConstraint constraintWithItem:self.parentView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:-50.0]];

    }
    [super updateConstraints];
}

@end

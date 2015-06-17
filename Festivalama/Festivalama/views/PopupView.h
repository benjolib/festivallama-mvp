//
//  PopupView.h
//  Festivalama
//
//  Created by Sztanyi Szabolcs on 28/05/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PopupViewButton, PopupView;

@protocol PopupViewDelegate <NSObject>

- (void)popupViewConfirmButtonPressed:(PopupView*)popupView;
@optional
- (void)popupViewCancelButtonPressed:(PopupView*)popupView;

@end

@interface PopupView : UIView

@property (nonatomic, weak) id <PopupViewDelegate> delegate;

@property (nonatomic, weak) IBOutlet UIView *popupBackgroundView;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *popupBackgroundViewHeightConstraint;

@property (nonatomic, strong) PopupViewButton *confirmButton;
@property (nonatomic, strong) PopupViewButton *cancelButton;
@property (nonatomic, weak) IBOutlet UIImageView *iconImageView;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *textLabel;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *textLabelHeightConstraint;

@property (nonatomic, weak) IBOutlet UIView *buttonsContainerView;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *buttonsContainerViewHeightConstraint;

- (instancetype)initWithDelegate:(id <PopupViewDelegate>)delegate;

- (void)setupWithConfirmButtonTitle:(NSString*)confirmTitle cancelButtonTitle:(NSString*)cancelTitle viewTitle:(NSString*)viewTitle text:(NSString*)text icon:(UIImage*)icon;

- (void)showPopupViewAnimationOnView:(UIView*)parentView withBlurredBackground:(BOOL)blurBackground;
- (void)dismissViewWithAnimation:(BOOL)animated;

@end

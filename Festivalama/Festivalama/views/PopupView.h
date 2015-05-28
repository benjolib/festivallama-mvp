//
//  PopupView.h
//  Festivalama
//
//  Created by Sztanyi Szabolcs on 28/05/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PopupViewButton;

@protocol PopupViewDelegate <NSObject>

- (void)popupViewConfirmButtonPressed;
@optional
- (void)popupViewCancelButtonPressed;

@end

@interface PopupView : UIView

@property (nonatomic, weak) id <PopupViewDelegate> delegate;

@property (nonatomic, weak) IBOutlet UIView *popupBackgroundView;
@property (nonatomic, weak) IBOutlet PopupViewButton *confirmButton;
@property (nonatomic, weak) IBOutlet PopupViewButton *cancelButton;
@property (nonatomic, weak) IBOutlet UIImageView *iconImageView;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *textLabel;

// constraints
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *textLabelHeightConstraint;

- (instancetype)initWithDelegate:(id <PopupViewDelegate>)delegate;

- (void)setupWithConfirmButtonTitle:(NSString*)confirmTitle cancelButtonTitle:(NSString*)cancelTitle viewTitle:(NSString*)viewTitle text:(NSString*)text icon:(UIImage*)icon;

- (void)showPopupViewAnimationOnView:(UIView*)parentView;
- (void)dismissViewWithAnimation:(BOOL)animated;

@end

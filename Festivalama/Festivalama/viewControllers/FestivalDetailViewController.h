//
//  FestivalDetailViewController.h
//  Festivalama
//
//  Created by Sztanyi Szabolcs on 04/06/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FestivalModel;

@interface FestivalDetailViewController : UIViewController

@property (nonatomic, strong) FestivalModel *festivalToDisplay;
@property (nonatomic, weak) IBOutlet UIView *containerView;

- (IBAction)shareButtonPressed:(id)sender;

@end

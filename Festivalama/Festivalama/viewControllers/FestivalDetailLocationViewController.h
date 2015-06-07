//
//  FestivalDetailLocationViewController.h
//  Festivalama
//
//  Created by Sztanyi Szabolcs on 07/06/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#import "BaseGradientViewController.h"

@class FestivalModel;

@interface FestivalDetailLocationViewController : BaseGradientViewController

@property (nonatomic, weak) FestivalModel *festivalToDisplay;

@property (nonatomic, weak) IBOutlet UILabel *locationNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *streetLabel;
@property (nonatomic, weak) IBOutlet UILabel *postCodeLabel;
@property (nonatomic, weak) IBOutlet UILabel *cityLabel;
@property (nonatomic, weak) IBOutlet UIButton *websiteButton;

@end

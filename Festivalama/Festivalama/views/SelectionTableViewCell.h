//
//  SelectionTableViewCell.h
//  Festivalama
//
//  Created by Sztanyi Szabolcs on 11/06/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectionTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UIView *cellBackgroundView;

+ (NSString*)cellIdentifier;

@end

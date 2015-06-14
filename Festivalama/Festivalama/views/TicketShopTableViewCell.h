//
//  TicketShopTableViewCell.h
//  Festivalama
//
//  Created by Szabolcs Sztanyi on 13/06/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface TicketShopTableViewCell : BaseTableViewCell

@property (nonatomic, weak) IBOutlet UITextField *textfield;
@property (nonatomic, weak) IBOutlet UIImageView *checkmarkView;

- (void)setFieldIsValid:(BOOL)valid;

- (BOOL)isFieldEmpty;
- (BOOL)isEmailValid;

@end

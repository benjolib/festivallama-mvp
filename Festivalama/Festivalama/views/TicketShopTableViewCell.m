//
//  TicketShopTableViewCell.m
//  Festivalama
//
//  Created by Szabolcs Sztanyi on 13/06/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#import "TicketShopTableViewCell.h"
#import "UITextField+Helper.h"

@implementation TicketShopTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.textfield.textColor = [UIColor whiteColor];
}

- (void)setFieldIsValid:(BOOL)valid
{
    self.checkmarkView.image = valid ? [UIImage imageNamed:@""] : nil;
}

- (BOOL)isFieldEmpty
{
    return [self.textfield isEmpty];
}

- (BOOL)isEmailValid
{
    return [self.textfield isEmailValid];
}

@end

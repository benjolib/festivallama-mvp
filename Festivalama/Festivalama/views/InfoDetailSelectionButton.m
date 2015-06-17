//
//  InfoDetailSelectionButton.m
//  Festivalama
//
//  Created by Sztanyi Szabolcs on 07/06/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#import "InfoDetailSelectionButton.h"
#import "UIFont+LatoFonts.h"

@implementation InfoDetailSelectionButton

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.titleLabel.font = [UIFont latoRegularFontWithSize:16.0];
}

- (void)setButtonPosition:(NSInteger)position selectedPosition:(NSInteger)selectedPosition active:(BOOL)active
{
    if (active) {
        self.backgroundColor = [UIColor clearColor];
    } else {
        if (selectedPosition != 1 && (position == selectedPosition+1 || position == selectedPosition -1)) {
            self.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.2];
        } else {
            self.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.1];
        }
    }
}

@end

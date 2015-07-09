//
//  SearchEmptyView.m
//  Festivalama
//
//  Created by Sztanyi Szabolcs on 14/06/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#import "SearchEmptyView.h"

@interface SearchEmptyView ()
@property (nonatomic, strong) IBOutlet UILabel *textLabel;
@end

@implementation SearchEmptyView

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSArray *bundle = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil];
        for (id object in bundle) {
            if ([object isKindOfClass:[SearchEmptyView class]]) {
                self = object;
                break;
            }
        }
    }
    return self;
}

+ (CGFloat)viewHeight
{
    return 270.0;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
}

- (void)showEmptyFilter
{
    self.textLabel.text = @"Bitte ändere Deine Filterauswahl. Derzeit könnten keine Festivals gefunden werden.";
}

- (void)showEmptySearch
{
    self.textLabel.text = @"Wir haben leider keine Ergebnisse für Deine Suche gefunden";
}

- (void)showEmptyCalendarView
{
    self.textLabel.text = @"Du hast bisher noch keine Festivals hinzugefügt";
}

- (void)setText:(NSString*)text
{
    self.textLabel.text = text;
}

@end

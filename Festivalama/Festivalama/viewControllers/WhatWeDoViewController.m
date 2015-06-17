//
//  WhatWeDoViewController.m
//  Festivalama
//
//  Created by Sztanyi Szabolcs on 05/06/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#import "WhatWeDoViewController.h"

@implementation WhatWeDoViewController



#pragma mark - view methods
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Was wir machen";

    NSString *htmlString = @"Vergiss den Alltag und schalte ab, denn die Festival Saison ist gestartet. Doch bei über 1.000 Festivals in ganz Europe ist es schwer den Überblick zu behalten. Wir von FestivaLama haben eine App entwickelt mit der Du spielend einfach den Überblick behalten kannst und täglich neue Vorschläge erhältst.<br><br>Über 1.000 Festivals in Europe<br>Über 10.000 Artists<br><br>Unsere App lernt was Dir gefällt und zeigt Dir nur Vorschläge an die zu Dir passen könnten.<br><br>Wir wünschen Dir eine tolle Zeit und viel Spaß mit der App!<br><br>Dein FestivaLama Team";

    [self.webview loadHTMLString:[NSString stringWithFormat:@"<html><body style=\"color:#fff;font-family:helvetica;font-size:18\">%@</body></html>", htmlString] baseURL:nil];
}

@end

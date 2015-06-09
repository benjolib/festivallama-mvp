//
//  PopularFestivalsViewController.m
//  Festivalama
//
//  Created by Sztanyi Szabolcs on 02/06/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#import "PopularFestivalsViewController.h"
#import "FestivalTableViewCell.h"
#import "LoadingTableView.h"

@interface PopularFestivalsViewController ()

@end

@implementation PopularFestivalsViewController

//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    return self.festivalsArray.count;
//}



#pragma mark - view methods
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Beliebte Festivals";

    [self loadSavedFestivals];
}

- (void)loadSavedFestivals
{
    // TODO:

    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end

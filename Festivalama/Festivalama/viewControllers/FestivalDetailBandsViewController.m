//
//  FestivalDetailBandsViewController.m
//  Festivalama
//
//  Created by Sztanyi Szabolcs on 07/06/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#import "FestivalDetailBandsViewController.h"
#import "FestivalModel.h"
#import "Band.h"

@interface FestivalDetailBandsViewController ()

@end

@implementation FestivalDetailBandsViewController

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.festivalToDisplay.bandsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }

    Band *band = self.festivalToDisplay.bandsArray[indexPath.row];
    cell.textLabel.text = band.name;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    return 0;
}

#pragma mark - view methods
- (void)viewDidLoad {
    [super viewDidLoad];

}

@end

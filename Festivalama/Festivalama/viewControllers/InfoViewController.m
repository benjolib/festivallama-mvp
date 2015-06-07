//
//  InfoViewController.m
//  Festivalama
//
//  Created by Sztanyi Szabolcs on 05/06/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#import "InfoViewController.h"
#import "BaseTableViewCell.h"

@interface InfoViewController ()
@property (nonatomic, strong) NSArray *cellTitlesArray;
@end

@implementation InfoViewController

- (NSArray*)cellTitlesArray
{
    if (!_cellTitlesArray) {
        _cellTitlesArray = @[@"Was wir machen", @"Teile die App", @"Bewerte die App"];
    }

    return _cellTitlesArray;
}

- (IBAction)backButtonPressed:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.cellTitlesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[BaseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = self.cellTitlesArray[indexPath.row];
    cell.textLabel.textColor = [UIColor whiteColor];
    UIImageView *accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"disclosureIcon"]];
    cell.accessoryView = accessoryView;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        [self performSegueWithIdentifier:@"openWhatWeDo" sender:nil];
    } else if (indexPath.row == 1) {
//        [self performSegueWithIdentifier:@"openShareTheApp" sender:nil];
    } else {
//        [self performSegueWithIdentifier:@"openRateTheApp" sender:nil];
    }
}

#pragma mark - view methods
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Über uns";

    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

@end

//
//  InfoViewController.m
//  Festivalama
//
//  Created by Sztanyi Szabolcs on 05/06/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#import "InfoViewController.h"
#import "BaseTableViewCell.h"
#import <StoreKit/StoreKit.h>

@interface InfoViewController () <SKStoreProductViewControllerDelegate>
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
        [self shareTheApp];
    } else {
        [self rateTheApp];
    }
}

- (void)shareTheApp
{
    NSString *stringToShare = @"FestivaLama App besorgt Dir die besten Festival Deals für Dich und Deine Freunde www.FestivaLama.io";
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[stringToShare]
                                                                                         applicationActivities:nil];
    activityViewController.excludedActivityTypes = @[UIActivityTypePostToWeibo,
                                                     UIActivityTypePrint,
                                                     UIActivityTypeCopyToPasteboard,
                                                     UIActivityTypeAssignToContact,
                                                     UIActivityTypePostToVimeo,
                                                     UIActivityTypePostToTencentWeibo,
                                                     UIActivityTypePostToFlickr,
                                                     UIActivityTypeSaveToCameraRoll,
                                                     UIActivityTypeAddToReadingList];
    [self presentViewController:activityViewController animated:YES completion:NULL];
}

- (void)rateTheApp
{
    SKStoreProductViewController *storeProductViewController = [[SKStoreProductViewController alloc] init];
    [storeProductViewController setDelegate:self];

    // TODO: needs App id
    [storeProductViewController loadProductWithParameters:@{SKStoreProductParameterITunesItemIdentifier : @"594467299"} completionBlock:^(BOOL result, NSError *error) {
        if (error) {
            NSLog(@"Error %@ with User Info %@.", error, [error userInfo]);

        } else {
            // Present Store Product View Controller
            [self presentViewController:storeProductViewController animated:YES completion:nil];
        }
    }];
}

- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController
{
    [viewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - view methods
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Über uns";

    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

@end

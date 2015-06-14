//
//  TicketShopDetailViewController.m
//  Festivalama
//
//  Created by Sztanyi Szabolcs on 10/06/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#import "TicketShopDetailViewController.h"
#import "FestivalModel.h"
#import "WhiteButton.h"
#import "TicketShopTableViewCell.h"
#import "TicketShopperClient.h"
#import "PopupView.h"

@interface TicketShopDetailViewController () <UITextFieldDelegate, PopupViewDelegate>
@property (nonatomic, strong) TicketShopperClient *shopperClient;
@property (nonatomic, strong) PopupView *confirmPopup;
@end

@implementation TicketShopDetailViewController

- (IBAction)sendButtonTapped:(id)sender
{
    TicketShopTableViewCell *cell1 = (TicketShopTableViewCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    TicketShopTableViewCell *cell2 = (TicketShopTableViewCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    TicketShopTableViewCell *cell3 = (TicketShopTableViewCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    
    BOOL allFieldsAreValid = YES;
    if ([cell1 isFieldEmpty]) {
        allFieldsAreValid = NO;
    }
    if ([cell2 isFieldEmpty]) {
        allFieldsAreValid = NO;
    }
    if ([cell3 isFieldEmpty] || ![cell3 isEmailValid]) {
        allFieldsAreValid = NO;
    }
    
    if (allFieldsAreValid)
    {
        // send the request
        self.shopperClient = [[TicketShopperClient alloc] init];
        [self.shopperClient sendTicketShopWithNumberOfTickets:[cell1.textfield.text integerValue]
                                                         name:cell2.textfield.text
                                                        email:cell3.textfield.text
                                              completionBlock:^(NSString *errorMessage, BOOL completed) {
                                                  if (completed)
                                                  {
                                                      
                                                  }
                                                  else
                                                  {
                                                      
                                                  }
        }];
    }
}

- (void)showConfirmationPopup
{
    self.confirmPopup = [[PopupView alloc] initWithDelegate:self];
    [self.confirmPopup setupWithConfirmButtonTitle:@"OK"
                                cancelButtonTitle:nil
                                        viewTitle:@"Unser Versprechen"
                                             text:@"Wir haben deine Anfrage erhalten und Du erhältst innerhalb 24 Stunden ein Angebot mit dem besten Preis per E-Mail"
                                             icon:[UIImage imageNamed:@""]];
    [self.confirmPopup showPopupViewAnimationOnView:self.view withBlurredBackground:YES];
}

#pragma mark - textField delegate methods
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - tableView methods
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TicketShopTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (indexPath.row == 0) {
        cell.textfield.placeholder = @"Wie viele Tickets benötigst du?";
        cell.textfield.keyboardType = UIKeyboardTypeDefault;
    } else if (indexPath.row == 1) {
        cell.textfield.placeholder = @"Wie ist dein Vorname?";
        cell.textfield.keyboardType = UIKeyboardTypeDefault;
    } else {
        cell.textfield.placeholder = @"Wie ist deine E-mail Adresse?";
        cell.textfield.keyboardType = UIKeyboardTypeEmailAddress;
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    TicketShopTableViewCell *cell = (TicketShopTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    [cell.textfield becomeFirstResponder];
}

#pragma mark - view methods
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.titleLabel.text = self.festivalToDisplay.name;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end

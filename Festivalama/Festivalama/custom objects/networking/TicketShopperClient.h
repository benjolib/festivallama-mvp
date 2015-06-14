//
//  TicketShopperClient.h
//  Festivalama
//
//  Created by Szabolcs Sztanyi on 13/06/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#import "AbstractClient.h"

@interface TicketShopperClient : AbstractClient

- (void)sendTicketShopWithNumberOfTickets:(NSInteger)ticketNumber name:(NSString*)name email:(NSString*)email completionBlock:(void (^)(NSString *errorMessage, BOOL completed))completionBlock;

@end

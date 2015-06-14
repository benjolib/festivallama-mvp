//
//  TicketShopperClient.m
//  Festivalama
//
//  Created by Szabolcs Sztanyi on 13/06/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#import "TicketShopperClient.h"

@implementation TicketShopperClient

- (void)sendTicketShopWithNumberOfTickets:(NSInteger)ticketNumber name:(NSString*)name email:(NSString*)email completionBlock:(void (^)(NSString *errorMessage, BOOL completed))completionBlock
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kBaseURL, kTicketShop]]];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[self defaultSessionConfiguration]];
    
    NSURLSessionDataTask *task = [self dataTaskWithRequest:request forSession:session withCompletionBlock:^(NSData *data, NSString *errorMessage, BOOL completed) {
        if (completionBlock) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(errorMessage, completed);
            });
        }
    }];
    
    [self startSessionTask:task];
}

@end

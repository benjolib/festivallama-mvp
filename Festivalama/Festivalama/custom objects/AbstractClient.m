//
//  AbstractClient.m
//  Festivalama
//
//  Created by Sztanyi Szabolcs on 28/05/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#import "AbstractClient.h"
#import "Reachability.h"
#import "AppDelegate.h"

@implementation AbstractClient

- (NSURLSessionConfiguration*)defaultSessionConfiguration
{
    // setup the configuration for the session
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    sessionConfiguration.allowsCellularAccess = YES;
    [sessionConfiguration setHTTPAdditionalHeaders:@{@"Content-Type": @"application/json"}];
    sessionConfiguration.timeoutIntervalForRequest = 20.0;
    sessionConfiguration.timeoutIntervalForResource = 20.0;
    sessionConfiguration.HTTPMaximumConnectionsPerHost = 1;
    return sessionConfiguration;
}

- (NSURLSessionDataTask*)dataTaskWithRequest:(NSURLRequest*)request forSession:(NSURLSession*)session withCompletionBlock:(void (^)(NSData *data, NSString *errorMessage, BOOL completed))completionBlock
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];

    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;

        NSInteger statusCode = httpResponse.statusCode;
        completionBlock(data, error.localizedDescription, (statusCode == 200));
    }];

    return task;
}

- (BOOL)startSessionTask:(NSURLSessionDataTask*)task
{
    if ([self isInternetConnectionAvailable])
    {
        [[NSOperationQueue new] addOperationWithBlock:^{
            [task resume];
        }];
        return YES;
    }
    else
    {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
        [appDelegate showNoInternetPopup];
        return NO;
    }
}

- (BOOL)isInternetConnectionAvailable
{
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    return networkStatus != NotReachable;
}

@end

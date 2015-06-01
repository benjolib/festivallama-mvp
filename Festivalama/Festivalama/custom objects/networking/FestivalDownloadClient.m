//
//  FestivalDownloadClient.m
//  Festivalama
//
//  Created by Sztanyi Szabolcs on 02/06/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#import "FestivalDownloadClient.h"
#import "FestivalModel.h"
#import "FestivalParser.h"

@interface FestivalDownloadClient ()
@property (nonatomic, strong) FestivalParser *festivalParser;
@end

@implementation FestivalDownloadClient

- (void)downloadAllFestivalsWithCompletionBlock:(void (^)(NSArray *festivalsArray, NSString *errorMessage, BOOL completed))completionBlock
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kBaseURL, kFestivalsList]]];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[self defaultSessionConfiguration]];

    __weak typeof(self) weakSelf = self;
    NSURLSessionDataTask *task = [self dataTaskWithRequest:request forSession:session withCompletionBlock:^(NSData *data, NSString *errorMessage, BOOL completed) {
        if (completed)
        {
            if (!weakSelf.festivalParser) {
                weakSelf.festivalParser = [FestivalParser new];
            }
            NSArray *festivals = [weakSelf.festivalParser parseJSONData:data];
            completionBlock(festivals, nil, YES);
        }
        else
        {

        }
    }];

    [self startSessionTask:task];
}

- (void)downloadFestivalsWithFilterModel:(FilterModel*)filterModel andCompletionBlock:(void (^)(NSArray *festivalsArray, NSString *errorMessage, BOOL completed))completionBlock
{

}

@end

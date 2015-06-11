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
#import "FilterModel.h"

@interface FestivalDownloadClient ()
@property (nonatomic, strong) FestivalParser *festivalParser;
@end

@implementation FestivalDownloadClient

- (void)downloadFestivalsWithURL:(NSURL*)url andCompletionBlock:(void (^)(NSArray *festivalsArray, NSString *errorMessage, BOOL completed))completionBlock
{
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
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
            if (completionBlock) {
                completionBlock(nil, errorMessage, NO);
            }
        }
    }];

    [self startSessionTask:task];
}

- (void)downloadFestivalsFromIndex:(NSInteger)startIndex limit:(NSInteger)numberOfItems filterModel:(FilterModel*)filterModel andCompletionBlock:(void (^)(NSArray *festivalsArray, NSString *errorMessage, BOOL completed))completionBlock
{
    NSMutableString *urlString = [NSMutableString stringWithFormat:@"%@%@?start=%ld&limit=%ld", kBaseURL, kFestivalsList, (long)startIndex, (long)numberOfItems];
    if (filterModel) {
        if (filterModel.selectedCountry) {
            [urlString appendString:[NSString stringWithFormat:@"&country=%@", filterModel.selectedCountry]];
        }
        if (filterModel.selectedPostCode) {
            [urlString appendString:[NSString stringWithFormat:@"&city=%@", filterModel.selectedPostCode]];
        }
        if (filterModel.selectedGenresArray.count > 0) {
            [urlString appendString:[NSString stringWithFormat:@"&genre=%@", filterModel.selectedGenresArray]];
        }
        if (filterModel.selectedBandsArray.count > 0) {
            [urlString appendString:[NSString stringWithFormat:@"&band=%@", filterModel.selectedBandsArray]];
        }
    }

    [self downloadFestivalsWithURL:[NSURL URLWithString:urlString] andCompletionBlock:completionBlock];
}

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
    // TODO:
}

- (void)downloadPopularFestivalsFromIndex:(NSInteger)startIndex limit:(NSInteger)numberOfItems filterModel:(FilterModel*)filterModel andCompletionBlock:(void (^)(NSArray *festivalsArray, NSString *errorMessage, BOOL completed))completionBlock
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@?start=%ld&limit=%ld", kBaseURL, kPopularFestivalsList, (long)startIndex, (long)numberOfItems];
    [self downloadFestivalsWithURL:[NSURL URLWithString:urlString] andCompletionBlock:completionBlock];
}

@end

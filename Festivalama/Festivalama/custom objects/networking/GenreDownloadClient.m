//
//  GenreDownloadClient.m
//  Festivalama
//
//  Created by Sztanyi Szabolcs on 28/05/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#import "GenreDownloadClient.h"
#import "GenreParser.h"

@interface GenreDownloadClient ()
@property (nonatomic, strong) GenreParser *genreParser;
@end

@implementation GenreDownloadClient

- (void)downloadAllGenresWithCompletionBlock:(void (^)(NSArray *sortedGenres, NSString *errorMessage, BOOL completed))completionBlock
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kBaseURL, kGenresList]]];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[self defaultSessionConfiguration]];

    __weak typeof(self) weakSelf = self;
    NSURLSessionDataTask *task = [self dataTaskWithRequest:request forSession:session withCompletionBlock:^(NSData *data, NSString *errorMessage, BOOL completed) {
        if (completed)
        {
            weakSelf.genreParser = [GenreParser new];
            NSArray *genresArray = [weakSelf.genreParser parseJSONData:data];

            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(genresArray, errorMessage, YES);
            });
        }
        else
        {

        }
    }];

    [self startSessionTask:task];
}

@end
